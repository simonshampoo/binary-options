pragma solidity 0.8.13;

import "./interfaces/IBet.sol";

contract Bet is IBet {
    address public playerOne;
    address public playerTwo;
    address public token;
    address public feesTo;
    address public peggedUSDToken;
    uint256 public betTimeStart;
    uint256 public betTimeEnd;
    uint256 public playerOneAmount;
    uint256 public playerTwoAmount;

    constructor(
        address _playerOne,
        address _playerTwo,
        address _token,
        address _peggedUSDToken,
        address _feesTo,
        uint256 _betTimeStart,
        uint256 _betTimeEnd,
        uint256 _playerOneAmount,
        uint256 _playerTwoAmount
    ) public ayable {
        playerOne = _playerOne;
        playerTwo = _playerTwo;
        token = _token;
        peggedUSDToken = _peggedUSDToken;
        feesTo = _feesTo;
        betTimeStart = _betTimeStart;
        betTimeEnd = _betTimeEnd;
        playerOneAmount = _playerOneAmount;
        playerTwoAmount = _playerTwoAmount;
    }

    bool playersHaveAccepted;

    modifier betHasEnded {
        require(block.timestamp >= betTimeEnd, "The bet hasn't ended yet.");
        _;
    }

    function isActiveBet() external view returns (bool) {
        return (block.timestamp <= betTimeEnd);
    }

    function payWinner() external betHasEnded returns (bool) {
        require(block.timestamp >= betTimeEnd, "Bet is not done yet.");
        uint256 currentTime = block.timestamp;
        address winner = checkCurrentWinner();
        uint256 amount = getPoolAmount();

        emit BetEnded(address(this), currentTime);

        winner.call({value: address(this).balance})("");

        emit PaidWinner(address(this), winner, amount, currentTime);
    }

    function refund(address payer) internal {
        (bool success, ) = payer.call{value: msg.value}("");

        require(success, "Something went wrong.");
    }

    //for player 2 to accept the bet, they must send a tx that matches the bet amount set by player one.
    receive() external payable {
        if (msg.sender != playerTwo) {
            refund(msg.sender);
        } else if (!playersHaveAccepted) {
            if (msg.value == playerTwoAmount) {
                //the bet is on!
                playersHaveAccepted = true;
            }
        } else {
            revert("Unknown error.");
        }
    }

    /*
    =======================================================
    *                                                     *
    *                     VIEW FUNCTIONS                  *
    *                                                     *
    =======================================================
    */
    function getPoolAmount() external view returns (uint256) {
        return address(this).balance;
    }

    function checkCurrentWinner() public view betHasEnded returns (address) {
        //now this is when we do that oracle shit
        //if the price is
    }
}
