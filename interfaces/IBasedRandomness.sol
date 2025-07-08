// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title IBasedRandomness - On-Chain Randomness Interface
 * @dev Interface for secure, verifiable random number generation without oracles
 */

/**
 * @dev Struct to store random number request data
 */
struct RandomRequest {
    uint256 requestBlock;    // Block number when request was made
    address requester;       // Address that made the request
    uint256 maxNumber;       // Maximum value for random numbers
    bool includeZero;        // Whether to include zero in range
    uint256 count;           // Number of random numbers to generate
    uint256 extraSecurity;   // Additional security blocks to wait
}

interface IBasedRandomness {
    
    // ═══════════════════════════════════════════════════════════════════
    // EVENTS
    // ═══════════════════════════════════════════════════════════════════
    
    /**
     * @dev Emitted when a random number request is prepared
     * @param requestId Unique identifier for the request
     * @param requester Address that made the request
     * @param maxNumber Maximum value for random numbers
     * @param includeZero Whether zero is included in range
     * @param extraSecurity Additional security blocks
     * @param count Number of random numbers to generate
     */
    event RandomNumberRequested(
        bytes32 indexed requestId,
        address indexed requester,
        uint256 maxNumber,
        bool includeZero,
        uint256 extraSecurity,
        uint256 count
    );

    /**
     * @dev Emitted when a random number is generated
     * @param requestId Request identifier
     * @param requester Address that generated the number
     * @param randomNumber The generated random number
     */
    event RandomNumberGenerated(
        bytes32 indexed requestId,
        address indexed requester,
        uint256 randomNumber
    );

    // ═══════════════════════════════════════════════════════════════════
    // PREPARATION FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @dev Prepare a random number request
     * @param maxNumber Maximum value for random numbers (1 to MAX_NUMBER_LIMIT)
     * @param count Number of random numbers to generate
     * @param initialCumulativeHash Initial entropy for request ID generation
     * @param includeZero Whether to include zero in the range
     * @param idOwner Address that can generate the numbers (0x0 = msg.sender)
     * @param extraSecurity Additional blocks to wait (0-50)
     * @param baseEntropyHash Custom entropy (0x0 = auto-generate from DEX)
     * @return requestId Unique identifier for this request
     */
    function prepareRandomNumbers(
        uint256 maxNumber,
        uint256 count,
        bytes32 initialCumulativeHash,
        bool includeZero,
        address idOwner,
        uint256 extraSecurity,
        bytes32 baseEntropyHash
    ) external returns (bytes32 requestId);

    /**
     * @dev Prepare multiple random number requests in batch
     * @param maxNumbers Array of maximum values (length > 0)
     * @param counts Array of counts (length 1 or same as maxNumbers)
     * @param initialCumulativeHash Initial entropy for request ID generation
     * @param includeZero Whether to include zero in ranges
     * @param idOwner Address that can generate numbers (0x0 = msg.sender)
     * @param extraSecurity Array of security levels (length 1 or same as maxNumbers)
     * @param baseEntropyHash Custom entropy (0x0 = auto-generate from DEX)
     * @return requestIds Array of unique identifiers for requests
     */
    function batchPrepareRandomNumbers(
        uint256[] calldata maxNumbers,
        uint256[] calldata counts,
        bytes32 initialCumulativeHash,
        bool includeZero,
        address idOwner,
        uint256[] calldata extraSecurity,
        bytes32 baseEntropyHash
    ) external returns (bytes32[] memory requestIds);

    // ═══════════════════════════════════════════════════════════════════
    // VIEW FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @dev Check if a request is ready for number generation
     * @param requestId The request identifier to check
     * @return ready True if enough blocks have passed for secure generation
     */
    function isRequestReady(bytes32 requestId) external view returns (bool ready);

    // ═══════════════════════════════════════════════════════════════════
    // GENERATION FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @dev Generate random numbers for a prepared request
     * @param requestId The request identifier
     * @return randomNumbers Array of generated random numbers
     */
    function generateRandomNumbers(bytes32 requestId) external returns (uint256[] memory randomNumbers);

    /**
     * @dev Generate random numbers for multiple requests
     * @param requestIds Array of request identifiers
     * @return randomNumbers 2D array of generated random numbers
     */
    function batchGenerateRandomNumbers(bytes32[] calldata requestIds) external returns (uint256[][] memory randomNumbers);
} 