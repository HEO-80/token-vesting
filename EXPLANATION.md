# Explanation - Token Vesting

## What is it?
A vesting contract locks ERC-20 tokens for a beneficiary and releases them
gradually over time — first after a cliff period, then linearly until the
full vesting duration is complete.

## Key concepts

### Cliff
A cliff is a minimum waiting period before any tokens are released.
If the cliff is 6 months, the beneficiary gets nothing until month 6,
then starts receiving tokens.

### Linear vesting
After the cliff, tokens unlock proportionally to time elapsed:
```
releasable = totalAmount * elapsed / vestingDuration
```

### Struct: VestingSchedule
Each beneficiary has one schedule stored on-chain:
| Field | Description |
|-------|-------------|
| `beneficiary` | Who receives the tokens |
| `totalAmount` | Total tokens locked |
| `released` | Tokens already claimed |
| `startTime` | When vesting started |
| `cliffDuration` | Seconds before first release |
| `vestingDuration` | Total vesting period in seconds |
| `revoked` | Whether owner cancelled it |

## Core functions

### `createVesting()`
Owner calls this to lock tokens for a beneficiary.
Requires prior `approve()` from owner to the vesting contract.

### `release()`
Beneficiary calls this to claim their vested tokens.
Only releases what has vested minus what was already claimed.

### `revoke()`
Owner can cancel a vesting schedule.
Already vested tokens go to beneficiary, remainder returns to owner.

## Hardhat 3 time testing note
In Hardhat 3 with EDR, `view` function calls do not reflect
`evm_setNextBlockTimestamp` changes. Time-sensitive assertions
must be done through real transactions, not view calls.