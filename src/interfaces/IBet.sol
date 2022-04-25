pragma solidity 0.8.13;

interface IBet {
    event PaidWinner(
        address indexed winner,
        address indexed loser,
        uint256 amountWon,
        uint256 timePaid
    );

    function calcProportionOfFunding(
        uint256 partyOneAmount,
        uint256 partyTwoAmount
    ) external view returns (uint256);

    function checkWinner() external view returns (address);

    function payWinner() external returns (bool);
}
