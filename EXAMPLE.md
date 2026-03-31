# Example - Token Vesting

## Real-world use case

A blockchain startup raises funding and allocates tokens to:
- **Team members** — 1 year cliff, 4 year vesting
- **Investors** — 6 month cliff, 2 year vesting
- **Advisors** — 3 month cliff, 1 year vesting

Without vesting, team members could dump all tokens on day 1.
With vesting, tokens unlock gradually — aligning incentives long-term.

## Deployment example
```solidity
// Deploy vesting contract
TokenVesting vesting = new TokenVesting(address(myToken));

// Approve tokens first
myToken.approve(address(vesting), teamAllocation);

// Create schedule for team member
vesting.createVesting(
    teamMember,           // beneficiary
    500_000 * 1e18,       // 500,000 tokens
    365 days,             // 1 year cliff
    4 * 365 days          // 4 year vesting
);
```

## Token flow
```
Month 0-12:   0 tokens released     (cliff period)
Month 12:     125,000 tokens unlock  (1 year of 4 elapsed)
Month 24:     250,000 tokens unlock  (2 years of 4 elapsed)
Month 36:     375,000 tokens unlock  (3 years of 4 elapsed)
Month 48:     500,000 tokens unlock  (fully vested)
```

## Revocation scenario
```solidity
// Team member leaves after 18 months
// Owner revokes — vested portion goes to member, rest returns to treasury
vesting.revoke(teamMember);
```

## Who uses this pattern?
- **Token launches** — team and investor allocations
- **DAOs** — contributor compensation over time
- **Play-to-earn** — reward distribution schedules
- **Freelance projects** — milestone-based token payments