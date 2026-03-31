# Steps - Token Vesting

## Setup
1. `npm init -y`
2. `npm pkg set type="module"`
3. `npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox-mocha-ethers`
4. `npm install @openzeppelin/contracts`
5. `npx hardhat --init` → Hardhat 3 → minimal
6. Add plugin to `hardhat.config.ts`:
```typescript
   import hardhatToolboxMochaEthers from "@nomicfoundation/hardhat-toolbox-mocha-ethers";
   export default defineConfig({
     plugins: [hardhatToolboxMochaEthers],
     solidity: { version: "0.8.28" }
   });
```

## Contracts created
- `contracts/TokenVesting.sol` — main vesting logic
- `contracts/MockERC20.sol` — simple ERC-20 for testing

## Key learnings
- In Hardhat 3 with EDR, `view` calls do not use the mined block timestamp
- Time-dependent tests must use real transactions (`release()`) not view calls
- `evm_mine` advances block timestamp by 1 second per block naturally
- Using `DURATION = 1n` (1 second) + mining 3 blocks is enough to pass cliff and duration

## Commands used
- `npx hardhat build` → Compile contracts
- `npx hardhat test` → Run test suite

## Result
✅ 6/6 tests passing
✅ Compiled with solc 0.8.28