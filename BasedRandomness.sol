// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./interfaces/IBasedRandomness.sol";

// crafted with ❤️  by BasedToschi

/**
 * @title BasedRandomness - On-Chain Randomness System
 * @dev Secure random number generation using DEX entropy and future block hashes
 * 
 * Two-Step Process:
 * 1. Prepare: Lock parameters using current block data + DEX entropy
 * 2. Generate: Use future block hashes (unpredictable at preparation time)
 * 
 * Entropy Sources: 6 DEX pools + block data for maximum security
 */

/**
 * @dev ERC20 interface for balance and supply queries
 */
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

contract BasedRandomness is IBasedRandomness {
    
    // ═══════════════════════════════════════════════════════════════════
    // CONSTANTS & IMMUTABLES
    // ═══════════════════════════════════════════════════════════════════
    
    /// @dev Maximum random number upper bound (2^120)
    uint256 public constant MAX_NUMBER_LIMIT = 2**120;

    // DEX addresses for entropy generation
    address private immutable USDC_TOKEN;
    address private immutable WETH_TOKEN;
    address private immutable UNI_USDC_ETH_V2;
    address private immutable UNI_USDC_ETH_03;
    address private immutable UNI_04;

    // ═══════════════════════════════════════════════════════════════════
    // STORAGE
    // ═══════════════════════════════════════════════════════════════════
    
    /// @dev Maps request IDs to their request data
    mapping(bytes32 => RandomRequest) public randomRequests;

    // ═══════════════════════════════════════════════════════════════════
    // CONSTRUCTOR
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @dev Initialize with DEX addresses for entropy
     */
    constructor(
        address USDCAddress, 
        address WETHAddress, 
        address UNIV2PoolAddress, 
        address UNIV3PoolAddress, 
        address UNIV4Address
    ) {
        USDC_TOKEN = USDCAddress;
        WETH_TOKEN = WETHAddress;
        UNI_USDC_ETH_V2 = UNIV2PoolAddress;
        UNI_USDC_ETH_03 = UNIV3PoolAddress;
        UNI_04 = UNIV4Address;
    }

    // ═══════════════════════════════════════════════════════════════════
    // PREPARATION FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @inheritdoc IBasedRandomness
     */
    function prepareRandomNumbers(
        uint256 maxNumber,
        uint256 count,
        bytes32 initialCumulativeHash,
        bool includeZero,
        address idOwner,
        uint256 extraSecurity,
        bytes32 baseEntropyHash
    ) public returns (bytes32) {
        // Parameter validation
        require(maxNumber > 0 && maxNumber <= MAX_NUMBER_LIMIT, "Invalid maxNumber");
        require(count > 0, "Count must be greater than 0");
        require(count <= 500, "Count cannot exceed 500 for gas safety");       
        require(extraSecurity <= 50, "Extra security must be less than 50");
        
        // Range exhaustion validation
        uint256 totalPossible = includeZero ? maxNumber + 1 : maxNumber;
        require(count <= totalPossible, "Cannot generate more unique numbers than range allows");
        
        // Owner resolution - use msg.sender if idOwner is zero
        address actualOwner = idOwner == address(0) ? msg.sender : idOwner;
        
        // Entropy collection - use provided or generate from DEX
        bytes32 realBaseEntropyHash = baseEntropyHash;
        if(baseEntropyHash == bytes32(0)) {
            realBaseEntropyHash = getEntropy(); // Generates from 6 DEX calls
        }
        
        // Get previous block hash for temporal entropy
        bytes32 previousBlockHash = blockhash(block.number - 1);
        
        // Generate unique request ID
        bytes32 requestId = keccak256(abi.encodePacked(
            maxNumber,
            initialCumulativeHash,
            actualOwner,
            previousBlockHash,
            realBaseEntropyHash,
            includeZero,
            block.number,
            block.prevrandao
        ));

        // Check for collisions
        if(randomRequests[requestId].requester != address(0)) {
            revert("Request already exists");
        }

        // Store request
        randomRequests[requestId] = RandomRequest({
            requestBlock: block.number,
            requester: actualOwner,
            maxNumber: maxNumber,
            includeZero: includeZero,
            count: count,
            extraSecurity: extraSecurity
        });

        emit RandomNumberRequested(requestId, actualOwner, maxNumber, includeZero, extraSecurity, count);
        return requestId;
    }

    /**
     * @inheritdoc IBasedRandomness
     */
    function batchPrepareRandomNumbers(
        uint256[] calldata maxNumbers,
        uint256[] calldata counts,
        bytes32 initialCumulativeHash,
        bool includeZero,
        address idOwner,
        uint256[] calldata extraSecurity,
        bytes32 baseEntropyHash
    ) external returns (bytes32[] memory) {
        // Validate arrays
        require(maxNumbers.length > 0, "Empty maxNumbers array");
        require(counts.length == 1 || counts.length == maxNumbers.length, "Invalid counts array length");
        require(extraSecurity.length == 1 || extraSecurity.length == maxNumbers.length, "Invalid security array length");
        
        bytes32[] memory requestIds = new bytes32[](maxNumbers.length);
        bytes32 rollingHash = initialCumulativeHash;

        // Process each request
        for (uint256 i = 0; i < maxNumbers.length; i++) {
            uint256 currentCount = counts.length == 1 ? counts[0] : counts[i];
            uint256 currentSecurity = extraSecurity.length == 1 ? extraSecurity[0] : extraSecurity[i];
            
            // Update rolling hash for uniqueness
            rollingHash = keccak256(abi.encodePacked(rollingHash, maxNumbers[i], i));

            // Handle entropy
            bytes32 realBaseEntropyHash = baseEntropyHash;
            if(baseEntropyHash == bytes32(0)) {
                realBaseEntropyHash = getEntropy();
            }
            
            // Create request
            requestIds[i] = prepareRandomNumbers(
                maxNumbers[i], 
                currentCount, 
                rollingHash,
                includeZero, 
                idOwner, 
                currentSecurity, 
                realBaseEntropyHash
            );
        }

        return requestIds;
    }

    // ═══════════════════════════════════════════════════════════════════
    // VIEW FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @inheritdoc IBasedRandomness
     */
    function isRequestReady(bytes32 requestId) external view returns (bool) {
        RandomRequest memory request = randomRequests[requestId];
        if (request.requester == address(0)) {
            return false; // Request doesn't exist
        }
        return block.number >= request.requestBlock + 4 + request.extraSecurity;
    }

    // ═══════════════════════════════════════════════════════════════════
    // GENERATION FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @inheritdoc IBasedRandomness
     */
    function generateRandomNumbers(bytes32 requestId) public returns (uint256[] memory) {
        // Validate request and authorization
        RandomRequest memory request = randomRequests[requestId];
        require(request.requester != address(0), "Invalid request ID");
        require(request.requester == msg.sender, "Only the original requester can generate the number");
        require(block.number >= request.requestBlock + 4 + request.extraSecurity, "Must wait required blocks before generating");

        uint256[] memory randomNumbers = new uint256[](request.count);
        
        // Create slots for transient storage
        bytes32 duplicateSlot = keccak256(abi.encodePacked(requestId, "UniqueNumberCheck"));
        bytes32 checkCountSlot = keccak256(abi.encodePacked(requestId, "CheckCount"));

        // Collect future block hashes for randomness
        bytes32 blockHashesCumulative = bytes32(0);
        for (uint j = 1; j <= 3 + request.extraSecurity; j++) {
            bytes32 futureBlockHash = blockhash(request.requestBlock + j);
            blockHashesCumulative = keccak256(abi.encodePacked(blockHashesCumulative, futureBlockHash));
        }

        // Generate random numbers
        for (uint256 i = 0; i < request.count; i++) {
            // Additional entropy for multi-number requests
            bytes32 additionalEntropy = i > 0 ? blockhash(block.number - i - 1) : bytes32(0);
            
            // Combine entropy sources
            uint256 randomSource = uint256(keccak256(abi.encodePacked(
                requestId,
                blockHashesCumulative,
                i,
                additionalEntropy
            )));

            // Map to range
            uint256 candidate;
            if (request.includeZero) {
                candidate = randomSource % (request.maxNumber + 1);
            } else {
                candidate = (randomSource % request.maxNumber) + 1;
            }

            // Check for duplicates and adjust using improved logic with transient storage
            bytes32 candidateSlot = keccak256(abi.encodePacked(duplicateSlot, candidate));
            bool isUsed;
            assembly {
                isUsed := tload(candidateSlot)
            }
            
            if (isUsed) {
                // Store original candidate for expanding circle search  
                uint256 originalCandidate = candidate;
                
                // Define range bounds
                uint256 minValue = request.includeZero ? 0 : 1;
                uint256 maxValue = request.maxNumber;
                
                // Use transient storage for search increment counter
                uint256 searchIncrement = 1;
                assembly {
                    tstore(checkCountSlot, 1)
                }
                
                // Expanding circle search: ±1, ±2, ±3, etc.
                while (isUsed && searchIncrement <= maxValue) {
                    bool upwardValid = (originalCandidate + searchIncrement) <= maxValue;
                    bool downwardValid = originalCandidate >= (minValue + searchIncrement);
                    
                    // Try upward direction: original + i
                    if (upwardValid) {
                        candidate = originalCandidate + searchIncrement;
                        candidateSlot = keccak256(abi.encodePacked(duplicateSlot, candidate));
                        assembly {
                            isUsed := tload(candidateSlot)
                        }
                        
                        // If found unique number, break immediately!
                        if (!isUsed) break;
                    }
                    
                    // Try downward direction: original - i  
                    if (downwardValid) {
                        candidate = originalCandidate - searchIncrement;
                        candidateSlot = keccak256(abi.encodePacked(duplicateSlot, candidate));
                        assembly {
                            isUsed := tload(candidateSlot)
                        }
                        
                        // If found unique number, break immediately!
                        if (!isUsed) break;
                    }
                    
                    // If both directions are out of bounds, we've searched the entire range
                    if (!upwardValid && !downwardValid) {
                        break;
                    }
                    
                    // Increment search radius and update transient storage
                    searchIncrement++;
                    assembly {
                        tstore(checkCountSlot, searchIncrement)
                    }
                }
                
                // Final check: If we still haven't found a unique number, range is exhausted
                if (isUsed) {
                    revert("Cannot generate unique numbers - range exhausted");
                }
                
                // Clean up transient storage
                assembly {
                    tstore(checkCountSlot, 0)
                }
            }

            // Mark as used in transient storage
            assembly {
                tstore(candidateSlot, 1)
            }
            
            randomNumbers[i] = candidate;
            emit RandomNumberGenerated(requestId, msg.sender, randomNumbers[i]);
        }

        // Clean up ALL transient storage - reset all used number flags
        for (uint256 i = 0; i < request.count; i++) {
            bytes32 numberSlot = keccak256(abi.encodePacked(duplicateSlot, randomNumbers[i]));
            assembly {
                tstore(numberSlot, 0)
            }
        }
        
        // Clean up search increment counter (in case it wasn't cleaned during collision resolution)
        assembly {
            tstore(checkCountSlot, 0)
        }

        // Clean up storage
        delete randomRequests[requestId];

        return randomNumbers;
    }

    /**
     * @inheritdoc IBasedRandomness
     */
    function batchGenerateRandomNumbers(bytes32[] calldata requestIds) external returns (uint256[][] memory) {        
        uint256[][] memory randomNumbers = new uint256[][](requestIds.length);

        for (uint256 i = 0; i < requestIds.length; i++) {
            randomNumbers[i] = generateRandomNumbers(requestIds[i]);
        }

        return randomNumbers;
    }

    // ═══════════════════════════════════════════════════════════════════
    // ENTROPY GENERATION
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @dev Generate entropy from DEX pool balances and token supplies
     * @return entropy Combined hash of all entropy sources
     */
    function getEntropy() private view returns (bytes32) {
        return keccak256(abi.encodePacked(
            // Pool balances
            IERC20(USDC_TOKEN).balanceOf(UNI_USDC_ETH_V2),
            IERC20(WETH_TOKEN).balanceOf(UNI_USDC_ETH_V2),
            IERC20(USDC_TOKEN).balanceOf(UNI_USDC_ETH_03),
            IERC20(WETH_TOKEN).balanceOf(UNI_USDC_ETH_03),
            IERC20(USDC_TOKEN).balanceOf(UNI_04),
            IERC20(WETH_TOKEN).balanceOf(UNI_04),
            
            // Token supplies
            IERC20(USDC_TOKEN).totalSupply(),
            IERC20(WETH_TOKEN).totalSupply()
        ));
    }
} 