pragma solidity 0.8.11;

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
    ) public view returns (uint256);

    function checkWinner() external view returns (address);

    function payWinner() external returns (bool);
}
