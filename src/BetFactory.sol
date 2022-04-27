pragma solidity 0.8.13;

import "./interfaces/IBetFactory.sol";
import "./Bet.sol";

/// @title Factory for Bet contracts
/// @author @shampoo_capital
/// @notice Users will interface with this contract to create bets on ERC20 token prices with another address
contract BetFactory is IBetFactory {
    /// @notice STATE VARIABLES
    address public immutable feesTo; // me, i take fees
    uint256 public immutable feeAmount; //how much i get. probably 0.30% of every bet

    /// @notice ALL OF THE BET CONTRACTS CREATED
    address[] public allBets;

    /// @notice ARRAY OF ALL THE BET CONTRACTS CREATED BY TWO ADDRESSES
    mapping(address => mapping(address => address[]))
        public betsBetweenToAddresses;

    /// @notice ALL OF THE BET CONTRACTS THAT A PLAYER HAS CREATED OR PARTICIPATED IN
    mapping(address => address[]) betsOfAddress;

    constructor(address _feesTo, uint256 _feeAmount) {
        feesTo = _feesTo;
        feeAmount = _feeAmount;
    }

    /**
    @notice creates a new Bet contract between two parties, namely msg.sender and another address
    @param challengee the other party in the bet 
    @param token the ERC20 token they want to bet on 
    @param betTimeStart when the bet begins 
    @param betTimeEnd when the bet will end 
    @param challengeeAmount the amount of ether the challengee puts down for the bet  
    @return address of the Bet contract that is created 
    **/
    function createBet(
        address challengee,
        address token,
        uint256 betTimeStart,
        uint256 betTimeEnd,
        uint256 challengeeAmount
    ) external payable returns (address) {
        require(
            challengee != address(0),
            "You cannot bet against the zero address."
        );
        require(msg.sender != challengee, "Identical addresses.");
        require(token != address(0), "Not a valid token.");
        require(
            msg.value > 0 && challengeeAmount > 0,
            "Both parties must bet a nonzero value."
        );

        address bet; 
        bytes memory bytecode = abi.encodePacked(
            type(Bet).creationCode,
            abi.encode(
                challengee,
                token,
                betTimeStart,
                betTimeEnd,
                challengeeAmount
            )
        );
        bytes32 salt = keccak256(
            abi.encodePacked(msg.sender, challengee, token)
        );

        assembly {
            bet := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

    //  i need to fix this. wtf going on?
    //     Bet newBet = new Bet(
    //         msg.sender,
    //         challengee,
    //         token,
    //         feesTo,
    //         betTimeStart,
    //         betTimeEnd,
    //         msg.value,
    //         challengeeAmount
    //     );

        betsBetweenToAddresses[msg.sender][challengee].push(bet);
        betsBetweenToAddresses[challengee][msg.sender].push(bet);

        betsOfAddress[msg.sender].push(bet);
        betsOfAddress[challengee].push(bet);
        allBets.push(bet);

        return bet; 
    }

    /*
    =======================================================
    *                                                     *
    *                     VIEW FUNCTIONS                  *
    *                                                     *
    =======================================================
    */
    function allBetsLength() external view returns (uint256) {
        return allBets.length;
    }

    function getBetsOfAddress(address playerOne)
        public
        view
        returns (address[] memory)
    {
        return betsOfAddress[playerOne];
    }

    function getBetsBetweenTwoAddresses(address playerOne, address playerTwo)
        public
        view
        returns (address[] memory)
    {
        return betsBetweenToAddresses[playerOne][playerTwo];
    }
}
