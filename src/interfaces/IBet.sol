pragma solidity 0.8.13;

interface IBet {
    event BetBegan(address indexed betContract, uint256 startTime);

    event BetEnded(address indexed betContract, uint256 endTime);

    event PaidWinner(
        address indexed betContract,
        address indexed winner,
        uint256 amountWon,
        uint256 timePaid
    );

    function isActiveBet() external view returns (bool);

    function getPoolAmount() external view returns (uint256);

    function payWinner() external returns (bool);
}
