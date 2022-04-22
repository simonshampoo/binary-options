pragma solidity 0.8.11;

contract Bet is IBet {
    address playerOne;
    address playerTwo;
    address token;
    uint256 betTimeStart;
    uint256 betTimeEnd;
    uint256 playerOneAmount;
    uint256 playerTwoAmount;

    constructor(
        address _playerOne,
        address _playerTwo,
        address _token,
        uint256 _betTimeStart,
        uint256 _betTimeEnd,
        uint256 _playerOneAmount,
        uint256 _playerTwoAmount
    ) {
        playerOne = _playerOne;
        playerTwo = _playerTwo;
        token = _token;
        betTimeStart = _betTimeStart;
        betTimeEnd = _betTimeEnd;
        playerOneAmount = _playerOneAmount;
        playerTwoAmount = _playerTwoAmount;
    }

    modifier betHasEnded {
        require(block.timestamp >= betTimeEnd, "The bet hasn't ended yet.");
        _; 
    }

    function calcProportionOfFunding(
        uint256 partyOneAmount,
        uint256 partyTwoAmount
    ) public view returns (uint256);

    function checkWinner() external view returns (address) betHasEnded {
    }

    function payWinner() external returns (bool) betHasEnded {

    }
}
