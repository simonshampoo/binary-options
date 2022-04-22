pragma solidity 0.8.11;

import "./interfaces/IBetFactory.sol";
import "./Bet.sol";

contract BetFactory is IBetFactory {
    address constant feesTo;

    address[] allBets;

    mapping(address => mapping(address => address[])) bets;

    function allBetsLength() external view returns (uint256) {
        return allBets.length;
    }

    function createBet(
        address playerOne,
        address playerTwo,
        address token,
        uint256 betTimeStart,
        uint256 betTimeEnd,
        uint256 playerOneAmount,
        uint256 playerTwoAmount
    ) external returns (address) {
        require(
            playerOne != address(0) && playerTwo != address(0),
            "You cannot bet against the zero address. Cheater."
        );
        require(
            playerOne != playerOne && playerTwo != playerTwo,
            "Identical addresses."
        );
        require(token != address(0), "Not a valid token.");
        require(
            playerOneAmount > 0 && playerTwoAmount > 0,
            "You must bet a nonzero value."
        );
        bytes memory bytecode = type(Bet).creationCode;
        bytes32 salt = keccak(abi.encodePacked(playerOne, playerTwo, token));

        assembly {
            bet := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        if (
            bets[playerOne][playerTwo] != token ||
            bets[playerOne][playerTwo] == address(0)
        ) {
            bets[playerOne][playerTwo].push(token);
        }

        if (
            bets[playerTwo][playerOne] != token ||
            bets[playerTwo][playerOne] == address(0)
        ) {
            bets[playerOne][playerTwo].push(token);
        }

        allBets.push(bet);
    }

    function getBetsBetweenTwoAddresses(address playerOne, address playerTwo)
        public
        view
        returns (address[])
    {
        return bets[playerOne][playerTwo];
    }
}
