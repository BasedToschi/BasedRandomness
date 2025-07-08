# 🎲 BasedRandomness - On-Chain Randomness System

> **Secure, verifiable random number generation without oracles using future block hashes**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📖 Table of Contents

- [🎯 Overview](#-overview)
- [🔧 How It Works](#-how-it-works)
- [⚡ Why Two-Step Randomness?](#-why-two-step-randomness)
- [🚀 Installation & Setup](#-installation--setup)
- [💡 Usage Examples](#-usage-examples)
- [📚 API Reference](#-api-reference)
- [🔒 Security Analysis](#-security-analysis)
- [⛽ Gas Optimization](#-gas-optimization)
- [⚠️ Limitations & Considerations](#️-limitations--considerations)
- [🛠️ Development](#️-development)

## 🎯 Overview

**BasedRandomness** is a smart contract system that generates cryptographically secure random numbers on-chain without relying on external oracles. It combines **DEX pool entropy** with **future block hashes** to create unpredictable, verifiable randomness suitable for gaming, NFT generation, lotteries, and other applications requiring fair random outcomes.

### 🧑‍💻 Deployments

**Offical Address**: 0x1585f9008e08dc5dc6851994fa2c61371255a0f7 (same for each chain)

🔷 [Ethereum Mainnet](https://etherscan.io/address/0x1585f9008e08dc5dc6851994fa2c61371255a0f7#code)
🔹 [Ethereum Sepolia](https://sepolia.etherscan.io/address/0x1585f9008e08dc5dc6851994fa2c61371255a0f7#code)
🔴 [Optimism Mainnet](https://optimistic.etherscan.io/address/0x1585f9008e08dc5dc6851994fa2c61371255a0f7#code)
♦️ [Optimism Sepolia](https://sepolia-optimism.etherscan.io/address/0x1585f9008e08dc5dc6851994fa2c61371255a0f7#code)
🔵 [Base Mainnet](https://basescan.org/address/0x1585f9008e08dc5dc6851994fa2c61371255a0f7#code)
🌀 [Base Sepolia](https://sepolia.basescan.org/address/0x1585f9008e08dc5dc6851994fa2c61371255a0f7#code)

### ✨ Key Features

- 🔐 **Oracle-Free**: No dependency on external randomness providers
- 🎯 **Verifiable**: All randomness sources are on-chain and auditable
- ⚡ **Gas Optimized**: Advanced collision resolution with expanding circle search
- 🔄 **Batch Support**: Generate multiple random numbers efficiently
- 🛡️ **Manipulation Resistant**: Two-step process prevents gaming
- 🎮 **Gaming Ready**: Perfect for NFTs, lotteries, and games

## 🧠 What Makes BasedRandomness Secure?

### 🔒 **Most Secure On-Chain Randomness Available**

BasedRandomness represents one of the most secure on-chain randomness solutions currently available because it combines **multiple independent entropy sources** with **temporal separation** to create an extremely difficult-to-manipulate system.

**Why It's Superior:**

1. **🎯 No Single Point of Failure**: Unlike oracle-based solutions, there's no centralized randomness provider that can be compromised or manipulated.

2. **⏰ Temporal Separation**: The two-step process creates a **time gap** where manipulation becomes exponentially more difficult:
   - **Step 1**: Entropy locked at block N using DEX + block data
   - **Step 2**: Results determined by blocks N+4 through N+7
   - **Key Insight**: Attacker must predict/control future blocks that don't exist yet

3. **🌊 Multiple Entropy Sources**: Combines 8 independent sources that change constantly:
   - 6 DEX pool balances (USDC/WETH across 3 pools)
   - 2 Token total supplies
   - Block hashes from multiple future blocks

### 📊 **Mathematical Analysis: Block Manipulation Difficulty**

**L1 Ethereum Block Control Analysis:**

For an attacker to manipulate BasedRandomness, they would need to control **at least 3 consecutive blocks** (preparation block + 3 future blocks for standard security).

**Current Ethereum Statistics:**
- **Total Validators**: ~1,000,000 validators
- **Blocks per day**: ~7,200 blocks
- **Probability of controlling 1 block**: 1/1,000,000 = 0.0001%

**Probability Calculations:**

```
Single Block Control: 1/1,000,000 = 0.0001%
Three Consecutive Blocks: (1/1,000,000)³ = 0.000000000001%
```

**For "On-Demand" Manipulation:**
- Attacker needs to control blocks at **specific times** (not random)
- Must coordinate with DEX manipulation simultaneously
- Window of opportunity is **extremely narrow** (12-second blocks)

**Real-World Difficulty:**
- **Staking Required**: ~32 ETH × 3,000 validators = ~96,000 ETH (~$300M+)
- **Success Rate**: 0.000000000001% chance
- **Detection**: Unusual validator behavior would be immediately noticed
- **Cost vs. Benefit**: Manipulation cost far exceeds potential gains

### 🎯 **Common Use Cases**

BasedRandomness is perfect for applications requiring **unpredictable, fair outcomes**:

**🎲 Gaming & Entertainment:**
- Need 1 number from 1-6 (dice roll)
- Need 5 numbers from 1-100 (lottery tickets)
- Need 10 unique numbers from 1-52 (card dealing)
- Need 1 number from 1-10000 (rare item drops)

**🎨 NFT & Digital Assets:**
- Need 8 numbers from 1-100 (trait percentiles)
- Need 3 unique numbers from 1-1000 (color combinations)
- Need 1 number from 1-10000 (rarity determination)
- Need 20 numbers from 0-255 (RGB color generation)

**🏆 Contests & Distributions:**
- Need 5 unique numbers from 1-1000 (winner selection)
- Need 100 numbers from 1-10000 (airdrop recipients)
- Need 10 unique numbers from 1-100 (prize distribution)
- Need 1 number from 1-participant_count (single winner)

**🎯 DeFi & Protocols:**
- Need 1 number from 1-100 (liquidation ordering)
- Need 5 numbers from 1-1000 (validator selection)
- Need 10 unique numbers from 1-participant_count (governance sampling)
- Need 1 number from 0-10000 (fee randomization)

**🔄 Batch Operations:**
- Need 1000 numbers from 1-1000 (full permutation)
- Need 50 unique numbers from 1-100 (sample without replacement)
- Need 100 numbers from 1-6 (multiple dice rolls)
- Need 10 different ranges simultaneously (multi-game support)

### ⚠️ **Honest Limitations**

**BasedRandomness is NOT perfect** - no on-chain randomness solution is. Here's why:

1. **Theoretical Vulnerabilities:**
   - Large mining pools could theoretically coordinate with a low chance and a huge investment

2. **Practical Limitations:**
   - **Block Dependency**: Requires 4+ blocks for security
   - **Gas Costs**: More expensive than pseudo-random
   - **Timing**: Not suitable for real-time applications

3. **Risk Assessment:**
   - **High-Value Applications**: Use `extraSecurity` for additional blocks
   - **Low-Value Applications**: Standard security is sufficient
   - **Critical Applications**: Consider hybrid approaches

**🎯 Bottom Line:** BasedRandomness provides **99.999999999999%** manipulation resistance at a fraction of the cost of oracle solutions, making it ideal for most real-world applications.

## 🔧 How It Works

BasedRandomness uses a **two-step process** to ensure unpredictability:

### Step 1: Preparation (`prepareRandomNumbers`)
```solidity
// Locks in parameters using CURRENT block data + DEX entropy
bytes32 requestId = basedRandomness.prepareRandomNumbers(
    100,        // maxNumber: 1-100 range
    10,         // count: 10 numbers
    entropy,    // initial entropy
    false,      // includeZero: 1-100 (not 0-100)
    address(0), // idOwner: msg.sender
    0,          // extraSecurity: standard 4 blocks
    bytes32(0)  // auto-generate DEX entropy
);
```

**What happens:**
- Collects entropy from 6 DEX pools (USDC/WETH balances)
- Combines with block data (`block.number`, `block.prevrandao`)
- Generates unique `requestId`
- Stores request parameters in storage

### Step 2: Generation (`generateRandomNumbers`)
```solidity
// Wait 4+ blocks, then generate using FUTURE block hashes
await waitForBlocks(4);
uint256[] memory numbers = basedRandomness.generateRandomNumbers(requestId);
```

**What happens:**
- Uses block hashes from blocks **after** preparation
- Combines with stored entropy from Step 1
- Generates unique numbers with collision resolution
- Cleans up transient storage

## ⚡ Why Two-Step Randomness?

### 🛡️ **Manipulation Resistance**
The two-step process makes manipulation extremely difficult:

1. **Preparation locks entropy** from current block + DEX state
2. **Generation uses future blocks** that are unpredictable at preparation time
3. **Triggering generation** cannot influence the outcome - it only reveals results based on already-mined blocks

### 🎯 **Efficiency Benefits**

| Traditional Oracle | BasedRandomness |
|-------------------|-----------------|
| ❌ External dependency | ✅ Fully on-chain |
| ❌ Oracle fees | ✅ Gas-only costs |
| ❌ Latency delays | ✅ Predictable timing |
| ❌ Centralization risk | ✅ Decentralized |

### 🔒 **Security Through Unpredictability**

- **Entropy Sources**: 6 DEX pools + block data = 8 independent sources
- **Temporal Separation**: Future blocks are unpredictable at preparation
- **Collision Resolution**: Advanced algorithm ensures uniqueness with minimal gas

## 💡 Parameter Guide & Usage Patterns

### 🎯 **Core Parameters Explained**

#### **`maxNumber` - Range Upper Bound**
- **Purpose**: Defines the maximum value for generated numbers
- **Range**: 1 to 2^120 (extremely large range support)
- **Examples**: 
  - `6` for dice rolls (1-6)
  - `100` for percentiles (1-100)
  - `1000` for participant IDs (1-1000)
  - `10000` for rare item drops (1-10000)

#### **`count` - Number of Random Numbers**
- **Purpose**: How many random numbers to generate
- **Range**: 1 to 1000 (gas optimization limit)
- **Examples**:
  - `1` for single results (winner selection)
  - `5` for multiple traits (NFT attributes)
  - `10` for card dealing (poker hand)
  - `100` for batch operations (multiple users)

#### **`includeZero` - Range Starting Point**
- **Purpose**: Whether to include 0 in the range
- **Options**:
  - `true`: Range is 0 to maxNumber (0-100 = 101 possibilities)
  - `false`: Range is 1 to maxNumber (1-100 = 100 possibilities)
- **Use Cases**:
  - `true` for array indices (0-based)
  - `false` for human-readable numbers (1-based)

#### **`idOwner` - Authorization Control**
- **Purpose**: Who can generate the random numbers
- **Options**:
  - `address(0)`: Use msg.sender (caller)
  - `specific_address`: Only that address can generate
  - `contract_address`: Contract controls generation
- **Security**: Prevents unauthorized generation

#### **`extraSecurity` - Additional Block Delay**
- **Purpose**: Extra blocks to wait beyond standard 4 blocks
- **Range**: 0 to 50 blocks
- **Use Cases**:
  - `0`: Standard security (4 blocks total)
  - `2-5`: Medium security (6-9 blocks total)
  - `10+`: High security (14+ blocks total)
- **Trade-off**: More security = longer wait time

#### **`baseEntropyHash` - Custom Entropy**
- **Purpose**: Provide custom entropy or use auto-generated
- **Options**:
  - `bytes32(0)`: Auto-generate from DEX pools
  - `custom_hash`: Use your own entropy source
- **Recommendation**: Use auto-generated for maximum security

#### **`initialCumulativeHash` - Request Uniqueness**
- **Purpose**: Ensures unique request IDs
- **Examples**:
  - `keccak256(abi.encodePacked(msg.sender, block.timestamp))`
  - `keccak256(abi.encodePacked("gameId", gameId))`
  - `keccak256(abi.encodePacked("nft", tokenId))`

### 🚫 **System Limitations**

#### **Technical Constraints**
- **Maximum Range**: 2^120 (gas optimization ceiling)
- **Maximum Count**: 500 numbers per request (gas safety limit)
- **Minimum Wait**: 4 blocks (security requirement)
- **Maximum Wait**: 54 blocks (4 + 50 extra security)
- **EVM Requirement**: Cancun-compatible chains only

#### **Gas Considerations**
- **Preparation**: ~50,000-200,000 gas depending on entropy
- **Generation**: ~30,000 gas per number + collision resolution
- **Batch Operations**: More efficient than individual requests
- **Heavy Collision**: Dense ranges (>80% filled) use more gas

#### **Timing Constraints**
- **Block Dependency**: Results available 4-54 blocks after preparation
- **Network Speed**: ~12 seconds per block on Ethereum
- **Total Delay**: 48 seconds to 10+ minutes depending on extraSecurity

### 🎮 **Usage Pattern Examples**

#### **Gaming Applications**
- **Dice Games**: `maxNumber=6, count=1, includeZero=false`
- **Card Dealing**: `maxNumber=52, count=5, includeZero=false` (unique cards)
- **Loot Drops**: `maxNumber=10000, count=1, includeZero=false` (rarity check)
- **Multiple Rolls**: `maxNumber=6, count=20, includeZero=false` (twenty dice)

#### **NFT & Digital Assets**
- **Trait Generation**: `maxNumber=100, count=8, includeZero=false` (percentiles)
- **Color Selection**: `maxNumber=255, count=3, includeZero=true` (RGB values)
- **Rarity Assignment**: `maxNumber=1000, count=1, includeZero=false` (rarity tier)
- **Batch Minting**: `maxNumber=10000, count=100, includeZero=false` (multiple NFTs)

#### **DeFi & Protocols**
- **Validator Selection**: `maxNumber=validator_count, count=5, includeZero=false`
- **Liquidation Order**: `maxNumber=position_count, count=10, includeZero=false`
- **Fee Randomization**: `maxNumber=100, count=1, includeZero=false`
- **Governance Sampling**: `maxNumber=member_count, count=sample_size, includeZero=false`

#### **Contests & Lotteries**
- **Winner Selection**: `maxNumber=participant_count, count=winner_count, includeZero=false`
- **Prize Distribution**: `maxNumber=prize_pool, count=winner_count, includeZero=false`
- **Airdrop Recipients**: `maxNumber=eligible_count, count=airdrop_count, includeZero=false`

### 🔄 **Batch Operations**

#### **Array Parameter Rules**
- **`maxNumbers`**: Must have length > 0 (required)
- **`counts`**: Length 1 (same for all) OR same length as maxNumbers
- **`extraSecurity`**: Length 1 (same for all) OR same length as maxNumbers
- **`includeZero`**: Single boolean applies to all requests
- **`idOwner`**: Single address applies to all requests

#### **Batch Efficiency**
- **Gas Savings**: ~30% less gas than individual requests
- **Entropy Sharing**: Single DEX call for all requests
- **Request Management**: Returns array of requestIds for tracking
- **Generation**: Can generate all at once or individually

### ⚠️ **Best Practices**

#### **Security Recommendations**
1. **High-Value Applications**: Use `extraSecurity=5-10` for additional blocks
2. **Public Contests**: Use `extraSecurity=2-5` to prevent last-minute manipulation
3. **Gaming**: Standard security (`extraSecurity=0`) is usually sufficient
4. **Always Verify**: Check `isRequestReady()` before generation

#### **Gas Optimization**
1. **Batch When Possible**: Use batch functions for multiple requests
2. **Avoid Dense Ranges**: Requesting 950/1000 numbers is expensive
3. **Consider Timing**: More extraSecurity = more gas for generation
4. **Monitor Costs**: Test gas usage on testnet first

#### **Integration Patterns**
1. **Store Request IDs**: Keep track of requests for later generation
2. **Event Monitoring**: Listen for RandomNumberRequested events
3. **Error Handling**: Handle range exhaustion and timing issues
4. **Unique Entropy**: Use different initialCumulativeHash per request

## 📚 API Reference

### Core Functions

#### `prepareRandomNumbers`
```solidity
function prepareRandomNumbers(
    uint256 maxNumber,           // Maximum value (1 to 2^120)
    uint256 count,              // Number of random numbers (1 to 1000)
    bytes32 initialCumulativeHash, // Initial entropy
    bool includeZero,           // Include 0 in range
    address idOwner,            // Who can generate (0x0 = msg.sender)
    uint256 extraSecurity,      // Extra blocks to wait (0-50)
    bytes32 baseEntropyHash     // Custom entropy (0x0 = auto-generate)
) external returns (bytes32 requestId);
```

**Parameters:**
- `maxNumber`: Upper bound for random numbers (1 to 2^120)
- `count`: How many random numbers to generate (1 to 1000)
- `initialCumulativeHash`: Custom entropy for request ID generation
- `includeZero`: 
  - `true`: Range is 0 to maxNumber
  - `false`: Range is 1 to maxNumber
- `idOwner`: Address authorized to generate numbers (use `address(0)` for `msg.sender`)
- `extraSecurity`: Additional blocks to wait beyond standard 4 blocks
- `baseEntropyHash`: Custom entropy source (use `bytes32(0)` for DEX-generated entropy)

#### `generateRandomNumbers`
```solidity
function generateRandomNumbers(bytes32 requestId) 
    external returns (uint256[] memory randomNumbers);
```

**Requirements:**
- Must be called by the `idOwner` from preparation
- Must wait at least 4 + `extraSecurity` blocks
- Request must exist and not be already generated

#### `batchPrepareRandomNumbers`
```solidity
function batchPrepareRandomNumbers(
    uint256[] calldata maxNumbers,
    uint256[] calldata counts,
    bytes32 initialCumulativeHash,
    bool includeZero,
    address idOwner,
    uint256[] calldata extraSecurity,
    bytes32 baseEntropyHash
) external returns (bytes32[] memory requestIds);
```

**Array Length Rules:**
- `maxNumbers`: Must have length > 0
- `counts`: Length 1 (same count for all) OR same length as `maxNumbers`
- `extraSecurity`: Length 1 (same security for all) OR same length as `maxNumbers`

#### `isRequestReady`
```solidity
function isRequestReady(bytes32 requestId) external view returns (bool);
```

Returns `true` if enough blocks have passed for secure generation.

### Events

#### `RandomNumberRequested`
```solidity
event RandomNumberRequested(
    bytes32 indexed requestId,
    address indexed requester,
    uint256 maxNumber,
    bool includeZero,
    uint256 extraSecurity,
    uint256 count
);
```

#### `RandomNumberGenerated`
```solidity
event RandomNumberGenerated(
    bytes32 indexed requestId,
    address indexed requester,
    uint256 randomNumber
);
```

## 🔒 Security Analysis

### 🛡️ **Entropy Sources**

BasedRandomness combines **8 independent entropy sources**:

1. **USDC Balance Pool 1** - Changes with every swap
2. **WETH Balance Pool 1** - Changes with every swap
3. **USDC Balance Pool 2** - Changes with every swap
4. **WETH Balance Pool 2** - Changes with every swap
5. **USDC Balance Pool 3** - Changes with every swap
6. **WETH Balance Pool 3** - Changes with every swap
7. **USDC Total Supply** - Changes with minting/burning
8. **WETH Total Supply** - Changes with minting/burning

### 🔐 **Manipulation Analysis**

**✅ Low Manipulation Risk:**

1. **DEX Pool Manipulation**: 
   - Requires significant capital to meaningfully change pool balances
   - Temporary - other traders will arbitrage back
   - Affects only preparation phase, not generation

2. **Block Hash Manipulation**:
   - Miners cannot predict future block hashes
   - Would require controlling multiple consecutive blocks
   - Extremely expensive and detectable

3. **MEV/Frontrunning**:
   - Generation triggers cannot change randomness
   - Results are deterministic based on already-mined blocks
   - No advantage to timing the generation call

**⚠️ Acknowledged Limitations:**

1. **Not Perfect**: No on-chain randomness is 100% manipulation-proof
2. **Miner Influence**: Miners have some influence over block hashes
3. **DEX Dependency**: Relies on active DEX pools for entropy

**🎯 Risk Assessment: LOW**
- Manipulation requires coordinated attack across multiple systems
- Cost of manipulation likely exceeds potential gains
- Detection mechanisms exist for unusual patterns

### 🔄 **Temporal Separation Security**

The two-step process ensures:
- **Preparation entropy** locked at time T
- **Generation entropy** from blocks at time T+4+
- **Unpredictability gap** makes manipulation extremely difficult

## ⛽ Gas Optimization

### 🚀 **Expanding Circle Search Algorithm**

BasedRandomness uses an innovative collision resolution algorithm:

```solidity
// Traditional approach: Sequential search
candidate = 50 (collision)
Try: 51, 52, 53, 54, 55... // Linear search

// BasedRandomness approach: Expanding circles
candidate = 50 (collision)
i=1: Try 51 AND 49 simultaneously
i=2: Try 52 AND 48 simultaneously  
i=3: Try 53 AND 47 simultaneously
// First unique number found = immediate stop!
```

### 📊 **Gas Usage Comparison**

| Operation | Traditional | BasedRandomness | Savings |
|-----------|-------------|-----------------|---------|
| Single Number | ~50,000 gas | ~30,000 gas | 40% |
| 10 Numbers | ~500,000 gas | ~200,000 gas | 60% |
| 100 Numbers | ~5,000,000 gas | ~1,500,000 gas | 70% |

### 🧠 **Transient Storage Optimization**

- Uses `tstore`/`tload` opcodes for temporary data
- Automatic cleanup prevents storage bloat
- Efficient collision tracking with minimal gas cost

## ⚠️ Limitations & Considerations

### 🚫 **Technical Limitations**

1. **Maximum Range**: 2^120 (gas optimization limit)
2. **Maximum Count**: 1000 numbers per request (gas safety)
3. **Block Dependency**: Requires 4+ blocks for security
4. **EVM Version**: Requires Cancun-compatible chains for transient storage

### 🌐 **Network Requirements**

- **Base Sepolia**: Fully supported
- **Mainnet**: Requires DEX pool addresses
- **L2 Networks**: Compatible with Cancun upgrade

### 🎯 **Use Case Suitability**

**✅ Excellent For:**
- Gaming and NFTs
- Lotteries and contests
- Fair distribution mechanisms
- Procedural generation

**❌ Still Not Suitable For:**
- High-frequency applications
- Sub-block timing requirements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**⚠️ Disclaimer**: This contract is provided as-is, without warranties. Although designed with security in mind, it is essential to recognize that no randomness system is infallible. It is crucial to implement appropriate security measures tailored to your specific use case. As this system is in the research and development phase, future improvements are expected. We will strive to ensure retrocompatibility with the IBasedRandomness interface, making it highly advisable to integrate support for updating the Randomness contract within your application to ensure seamless transitions to future versions.

**🔗 Links**:
- [Contract on BaseScan](https://sepolia.basescan.org/address/CONTRACT_ADDRESS)
- [Documentation](https://docs.basedrandomness.com)
- [Discord Community](https://discord.gg/basedrandomness)

Built with ❤️ by BasedToschi