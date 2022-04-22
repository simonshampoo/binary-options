pragma solidity 0.8.11;

interface IBetFactory {
    event BetCreated(
        address indexed playerOne,
        address indexed playerTwo,
        address tokenAddress,
        uint256 startTime,
        uint256 endTime,
        uint256 playerOneAmount,
        uint256 playerTwoAmount
    );

    event BetEnded(
        address indexed playerOne,
        address indexed playerTwo,
        address token,
        uint256 startTime,
        uint256 endTime,
        uint256 playerOneAmount,
        uint256 playerTwoAmount
    );

    // will create a new contract representing the bet between the two parties
    function createBet(
        address playerOne,
        address playerTwo,
        address tokenAddress,
        uint256 startTime,
        uint256 endTime,
        uint256 playerOneAmount,
        uint256 playerTwoAmount
    ) external returns (address);
}
