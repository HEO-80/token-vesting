import { expect } from "chai";
import { network } from "hardhat";

describe("TokenVesting", function () {
  let vesting, token, owner, beneficiary, addr1;
  const TOTAL_AMOUNT = 1000n * 10n ** 18n;
  const CLIFF = 60n;
  const DURATION = 365n;

  beforeEach(async function () {
    const { ethers } = await network.connect();
    [owner, beneficiary, addr1] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("MockERC20");
    token = await Token.deploy("Test Token", "TST", 10000n * 10n ** 18n);

    const Vesting = await ethers.getContractFactory("TokenVesting");
    vesting = await Vesting.deploy(await token.getAddress());

    await token.approve(await vesting.getAddress(), TOTAL_AMOUNT);
  });

  it("Should create a vesting schedule", async function () {
    await vesting.createVesting(beneficiary.address, TOTAL_AMOUNT, CLIFF, DURATION);
    const schedule = await vesting.vestingSchedules(beneficiary.address);
    expect(schedule.totalAmount).to.equal(TOTAL_AMOUNT);
    expect(schedule.released).to.equal(0n);
  });

  it("Should not release tokens before cliff", async function () {
    await vesting.createVesting(beneficiary.address, TOTAL_AMOUNT, CLIFF, DURATION);
    const releasable = await vesting.releasableAmount(beneficiary.address);
    expect(releasable).to.equal(0n);
  });

  it("Should release all tokens after full duration", async function () {
    const { ethers } = await network.connect();
    
    const LARGE_CLIFF = 0n;
    const LARGE_DURATION = 1n;
    
    await vesting.createVesting(beneficiary.address, TOTAL_AMOUNT, LARGE_CLIFF, LARGE_DURATION);

    // Mine blocks — each block advances timestamp by 1 second
    await ethers.provider.send("evm_mine", []);
    await ethers.provider.send("evm_mine", []);
    await ethers.provider.send("evm_mine", []);

    // release() is a transaction — uses real block timestamp
    await vesting.connect(beneficiary).release();
    const balance = await token.balanceOf(beneficiary.address);
    expect(balance).to.equal(TOTAL_AMOUNT);
  });

  it("Should not create duplicate vesting for same beneficiary", async function () {
    await vesting.createVesting(beneficiary.address, TOTAL_AMOUNT, CLIFF, DURATION);
    await token.approve(await vesting.getAddress(), TOTAL_AMOUNT);
    await expect(
      vesting.createVesting(beneficiary.address, TOTAL_AMOUNT, CLIFF, DURATION)
    ).to.be.revertedWith("Vesting already exists");
  });

  it("Non-owner cannot create vesting", async function () {
    await expect(
      vesting.connect(addr1).createVesting(beneficiary.address, TOTAL_AMOUNT, CLIFF, DURATION)
    ).to.be.revertedWithCustomError(vesting, "OwnableUnauthorizedAccount");
  });

  it("Owner can revoke vesting", async function () {
    await vesting.createVesting(beneficiary.address, TOTAL_AMOUNT, CLIFF, DURATION);
    await vesting.revoke(beneficiary.address);
    const schedule = await vesting.vestingSchedules(beneficiary.address);
    expect(schedule.revoked).to.equal(true);
  });


});