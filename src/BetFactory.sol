pragma solidity 0.8.11;

import "./interfaces/IBetFactory.sol";
import "./Bet.sol";

contract BetFactory is IBetFactory {
    address public constant feesTo; // me, i take fees
    uint256 public constant feeAmount; //how much i get. probably 0.30% of every bet

    address[] public allBets; // addresses of all the bet contracts

    //returns an array of all the bet contracts created between two addresses
    // will return each bet contract created by two addresses
    mapping(address => mapping(address => address[])) public bets;

    //all the bets contracts that a player has created/participated in
    mapping(address => address) betsOfAddress;

    function createBet(
        address playerOne,
        address playerTwo,
        address token,
        address feesTo,
        uint256 betTimeStart,
        uint256 betTimeEnd,
        uint256 playerOneAmount,
        uint256 playerTwoAmount
    ) external returns (address) {
        require(
            playerOne == msg.sender,
            "You must participate in the bets you create."
        );
        require(
            playerOne != address(0) && playerTwo != address(0),
            "You cannot bet against the zero address."
        );
        require(playerOne != playerTwo, "Identical addresses.");
        require(token != address(0), "Not a valid token.");
        require(
            playerOneAmount > 0 && playerTwoAmount > 0,
            "Both parties must bet a nonzero value."
        );
        bytes memory bytecode = abi.encodePacked(
            type(Bet).creationCode,
            abi.encode(
                playerOne,
                playerTwo,
                token,
                feesTo,
                betTimeStart,
                betTimeEnd,
                playerOneAmount,
                playerTwoAmount
            )
        );
        bytes32 memory salt = keccak256(
            abi.encodePacked(playerOne, playerTwo, token)
        );

        assembly {
            bet := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }

        bets[playerOne][playerTwo].push(bet);
        bets[playerTwo][playerOne].push(bet);

        betsOfAddress[playerOne].push(bet);
        betsOfAddress[playerTwo].push(bet);
        allBets.push(bet);
    }

    function allBetsLength() external view returns (uint256) {
        return allBets.length;
    }

    function getBetsOfAddress(address playerOne)
        public
        view
        returns (address[])
    {
        return betsOfAddress[playerOne];
    }

    function getBetsBetweenTwoAddresses(address playerOne, address playerTwo)
        public
        view
        returns (address[])
    {
        return bets[playerOne][playerTwo];
    }
}
