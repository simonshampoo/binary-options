pragma solidity 0.8.11;

import "./interfaces/IBetFactory.sol";
import "./Bet.sol";

contract BetFactory is IBetFactory {
    address public constant feesTo;

    address[] public allBets;

    mapping(address => mapping(address => address[])) public bets;
    mapping(address => Bet[]) betsOfAddress;

    function allBetsLength() external view returns (uint256) {
        return allBets.length;
    }

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
        bytes memory bytecode = abi.encodePacked(
            type(Bet).creationCode,
            abi.encode(
                playerOne,
                playerTwo,
                token,
                betTimeStart,
                betTimeEnd,
                playerOneAmount,
                playerTwoAmount
            )
        );
        bytes32 salt = keccak(abi.encodePacked(playerOne, playerTwo, token));

        assembly {
            bet := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }

        bets[playerOne][playerTwo].push(token);
        bets[playerTwo][playerOne].push(token);

        betsOfAddress[playerOne].push(bet);
        betsOfAddress[playerTwo].push(bet);
        allBets.push(bet);
    }

    function getBetsOfAddress(address playerOne, address playerTwo)
        public
        view
        returns (address[])
    {
        return bets[playerOne][playerTwo];
    }

    function getBetsBetweenTwoAddresses(address playerOne, address playerTwo)
        public
        view
        returns (address[])
    {}
}
