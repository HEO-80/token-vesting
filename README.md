<div align="center">

<br/>

# 🔒 Token Vesting

### Lock tokens. Release over time. Build trust.

A smart contract that locks ERC-20 tokens for beneficiaries with a configurable
cliff period and linear vesting schedule — standard for team allocations and investor deals.

<br/>

[![Solidity](https://img.shields.io/badge/Solidity-0.8.28-363636?style=for-the-badge&logo=solidity&logoColor=white)](https://soliditylang.org/)
[![Hardhat](https://img.shields.io/badge/Hardhat-3.x-f7df1e?style=for-the-badge)](https://hardhat.org/)
[![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-5.x-4e5ee4?style=for-the-badge&logo=openzeppelin&logoColor=white)](https://openzeppelin.com/)
[![Tests](https://img.shields.io/badge/Tests-6%2F6%20passing-brightgreen?style=for-the-badge)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-c792ea?style=for-the-badge)](LICENSE)

<br/>

> Part of the **Solidity Portfolio** by [HEO-80](https://github.com/HEO-80/solidity-portfolio)

<br/>

</div>

---

## 💼 Need a vesting contract?

I build token vesting contracts that are tested, documented, and verified on Etherscan.
Cliff schedules, linear release, multi-beneficiary — tell me what you need.

> 📩 [Fiverr](https://fiverr.com/hectoroviedo23) · [Upwork](#) · [LinkedIn](https://linkedin.com/in/hectorob)

---

## 📋 Overview

| Property | Value |
|----------|-------|
| Standard | ERC-20 compatible |
| Cliff | Configurable (seconds) |
| Vesting | Linear release after cliff |
| Multi-beneficiary | One schedule per address |
| Revocable | Owner can revoke and recover tokens |

---

## ⚙️ How it works

1. **Add beneficiary** — owner sets address, total amount, cliff duration, and vesting duration
2. **Cliff period** — no tokens can be claimed until cliff expires
3. **Linear release** — after cliff, tokens unlock proportionally every second
4. **Claim** — beneficiary calls `release()` to withdraw available tokens
5. **Revoke** — owner can cancel vesting and recover unvested tokens at any time

---

## 🔐 Key functions
```solidity
// Add a new vesting schedule
function addBeneficiary(
    address beneficiary,
    uint256 amount,
    uint256 cliffDuration,
    uint256 vestingDuration
) external onlyOwner

// Claim available tokens
function release() external

// Check claimable amount
function releasable(address beneficiary) public view returns (uint256)

// Revoke vesting (owner only)
function revoke(address beneficiary) external onlyOwner
```

---

## 🏦 Real-world use cases

- **Team token allocation** — lock founder/team tokens with 1-year cliff, 4-year vest
- **Investor deal** — structured release tied to project milestones
- **Advisor compensation** — gradual unlock as advisors contribute over time
- **DAO treasury** — controlled token distribution to contributors

---

## 🧪 Test coverage

| Test | Status |
|------|--------|
| Cliff not reached — no release | ✅ |
| Linear release after cliff | ✅ |
| Full release at end of vesting | ✅ |
| Multi-beneficiary independence | ✅ |
| Owner revoke + token recovery | ✅ |
| Revert on unauthorized access | ✅ |

---

## 🧰 Tech Stack

<div align="center">

<img src="https://img.shields.io/badge/Solidity-363636?style=for-the-badge&logo=solidity&logoColor=white"/>
<img src="https://img.shields.io/badge/Hardhat-f7df1e?style=for-the-badge&logoColor=black"/>
<img src="https://img.shields.io/badge/OpenZeppelin-4e5ee4?style=for-the-badge&logo=openzeppelin&logoColor=white"/>
<img src="https://img.shields.io/badge/Ethers.js-2535a0?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Sepolia-6f3ff5?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Etherscan-21325b?style=for-the-badge"/>

</div>

---

## 🚀 Setup
```bash
git clone https://github.com/HEO-80/token-vesting.git
cd token-vesting
npm install
npx hardhat test
```

---

## 📁 Repository Structure
token-vesting/
├── contracts/
│   └── TokenVesting.sol      # Main vesting contract
├── test/
│   └── TokenVesting.test.js  # Full test suite
├── README.md                 # This file
├── STEPS.md                  # Exact deployment commands
├── EXPLANATION.md            # How the contract works in detail
└── EXAMPLE.md                # Real-world use case and scenario

---

## 👤 Author

**Héctor Oviedo** — Full Stack Developer & DeFi Researcher

[![GitHub](https://img.shields.io/badge/GitHub-HEO--80-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/HEO-80)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-hectorob-0077b5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/hectorob)

---

## 📄 License

MIT — see [LICENSE](LICENSE)

[![License: MIT](https://img.shields.io/badge/License-MIT-c792ea?style=for-the-badge)](LICENSE)

---

<div align="center">

*Lock tokens. Release over time. Build trust.*

</div>
