// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title TokenVesting - Token vesting with cliff and linear release
/// @author HEO-80
/// @notice Allows locking tokens for beneficiaries with a cliff and linear vesting period
contract TokenVesting is Ownable {

    struct VestingSchedule {
        address beneficiary;
        uint256 totalAmount;
        uint256 released;
        uint256 startTime;
        uint256 cliffDuration;
        uint256 vestingDuration;
        bool revoked;
    }

    IERC20 public immutable token;
    mapping(address => VestingSchedule) public vestingSchedules;

    event VestingCreated(address indexed beneficiary, uint256 amount, uint256 cliff, uint256 duration);
    event TokensReleased(address indexed beneficiary, uint256 amount);
    event VestingRevoked(address indexed beneficiary, uint256 amountReturned);

    constructor(address _token) Ownable(msg.sender) {
        require(_token != address(0), "Invalid token address");
        token = IERC20(_token);
    }

    /// @notice Create a vesting schedule for a beneficiary
    /// @param beneficiary Address that will receive the tokens
    /// @param amount Total tokens to vest
    /// @param cliffDuration Seconds before any tokens are released
    /// @param vestingDuration Total seconds of the vesting period
    function createVesting(
        address beneficiary,
        uint256 amount,
        uint256 cliffDuration,
        uint256 vestingDuration
    ) external onlyOwner {
        require(beneficiary != address(0), "Invalid beneficiary");
        require(amount > 0, "Amount must be greater than 0");
        require(vestingDuration > 0, "Duration must be greater than 0");
        require(vestingSchedules[beneficiary].totalAmount == 0, "Vesting already exists");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");

        vestingSchedules[beneficiary] = VestingSchedule({
            beneficiary: beneficiary,
            totalAmount: amount,
            released: 0,
            startTime: block.timestamp,
            cliffDuration: cliffDuration,
            vestingDuration: vestingDuration,
            revoked: false
        });

        emit VestingCreated(beneficiary, amount, cliffDuration, vestingDuration);
    }

    /// @notice Release vested tokens for the caller
    function release() external {
        VestingSchedule storage schedule = vestingSchedules[msg.sender];
        require(schedule.totalAmount > 0, "No vesting schedule found");
        require(!schedule.revoked, "Vesting revoked");

        uint256 releasable = _releasableAmount(schedule);
        require(releasable > 0, "No tokens to release");

        schedule.released += releasable;
        token.transfer(msg.sender, releasable);

        emit TokensReleased(msg.sender, releasable);
    }

    /// @notice Revoke vesting for a beneficiary — unreleased tokens return to owner
    function revoke(address beneficiary) external onlyOwner {
        VestingSchedule storage schedule = vestingSchedules[beneficiary];
        require(schedule.totalAmount > 0, "No vesting schedule found");
        require(!schedule.revoked, "Already revoked");

        uint256 releasable = _releasableAmount(schedule);
        uint256 refund = schedule.totalAmount - schedule.released - releasable;

        schedule.revoked = true;

        if (releasable > 0) {
            schedule.released += releasable;
            token.transfer(beneficiary, releasable);
        }

        if (refund > 0) {
            token.transfer(owner(), refund);
        }

        emit VestingRevoked(beneficiary, refund);
    }

    /// @notice Returns how many tokens a beneficiary can release right now
    function releasableAmount(address beneficiary) external view returns (uint256) {
        return _releasableAmount(vestingSchedules[beneficiary]);
    }

    /// @dev Internal calculation of releasable tokens
    function _releasableAmount(VestingSchedule storage schedule) internal view returns (uint256) {
        if (schedule.revoked) return 0;
        return _vestedAmount(schedule) - schedule.released;
    }

    /// @dev Calculate total vested amount at current timestamp
    function _vestedAmount(VestingSchedule storage schedule) internal view returns (uint256) {
        uint256 elapsed = block.timestamp - schedule.startTime;

        if (elapsed < schedule.cliffDuration) return 0;
        if (elapsed >= schedule.vestingDuration) return schedule.totalAmount;

        return (schedule.totalAmount * elapsed) / schedule.vestingDuration;
    }
}