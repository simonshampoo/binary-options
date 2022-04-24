pragma solidity 0.8.11;

contract Bet is IBet {
    address public playerOne;
    address public playerTwo;
    address public token;
    address public feesTo;
    uint256 public betTimeStart;
    uint256 public betTimeEnd;
    uint256 public playerOneAmount;
    uint256 public playerTwoAmount;

    constructor(
        address memory _playerOne,
        address memory _playerTwo,
        address memory _token,
        address memory _feesTo,
        uint256 memory _betTimeStart,
        uint256 memory _betTimeEnd,
        uint256 memory _playerOneAmount,
        uint256 memory _playerTwoAmount
    ) public {
        playerOne = _playerOne;
        playerTwo = _playerTwo;
        token = _token;
        feesTo = _feesTo;
        betTimeStart = _betTimeStart;
        betTimeEnd = _betTimeEnd;
        playerOneAmount = _playerOneAmount;
        playerTwoAmount = _playerTwoAmount;
    }

    modifier betHasEnded {
        require(block.timestamp >= betTimeEnd, "The bet hasn't ended yet.");
        _;
    }

    function isActiveBet() external returns (bool) {
        return (block.timestamp <= betTimeEnd);
    }

    function getPoolAmount(uint256 partyOneAmount, uint256 partyTwoAmount)
        public
        pure
        returns (uint256)
    {
        return partyOneAmount + partyTwoAmount;
    }

    function checkWinner() external view betHasEnded returns (address) {
        //now this is when we do that oracle shit
        //if the price is
    }

    function payWinner() external betHasEnded returns (bool) {}

    //for player 2 to accept the bet, they must send a tx that matches the bet amount set by player one.
    receive() external payable {
        if (msg.sender != playerTwo) {
            refund(msg.sender);
        }
        else {

        }
    }

    function refund(address payer) internal {
        payer.call{value: msg.value}("");
    }
}
