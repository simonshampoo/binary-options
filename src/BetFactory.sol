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

    constructor(address _feesTo, uint256 _feeAmount) public {
        feesTo = _feesTo;
        feeAmount = _feeAmount;
    }

    /**
    @notice creates a new Bet contract between two parties, namely msg.sender and another address
    @param challengee the other party in the bet 
    @param token the ERC20 token they want to bet on 
    @param peggedUSDToken the USD-pegged token that they will choose (DAI or USDC)
    @param betTimeStart when the bet begins 
    @param betTimeEnd when the bet will end 
    @param challengeeAmount the amount of ether the challengee puts down for the bet  
    @return address of the Bet contract that is created 
    **/
    function createBet(
        address challengee,
        address token,
        address peggedUSDToken,
        uint256 betTimeStart,
        uint256 betTimeEnd,
        uint256 challengeeAmount
    ) external payable returns (address) {
        require(
            peggedUSDToken == 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 ||
                peggedUSDToken == 0x6b175474e89094c44da98b954eedeac495271d0f,
            "Must be DAI or USDC."
        );
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
                msg.sender,
                challengee,
                token,
                peggedUSDToken,
                feesTo,
                betTimeStart,
                betTimeEnd,
                msg.value,
                challengeeAmount
            )
        );
        bytes32 salt = keccak256(
            abi.encodePacked(msg.sender, challengee, token)
        );

        assembly {
            bet := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

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

    function getCreationBytecode(
        address _playerOne,
        address _playerTwo,
        address _token,
        address _peggedUSDToken,
        address _feesTo,
        uint256 _betTimeStart,
        uint256 _betTimeEnd,
        uint256 _playerOneAmount,
        uint256 _playerTwoAmount
    ) internal pure returns (bytes memory) {
        bytes memory bytecode = type(Bet).creationCode;
        return
            abi.encodePacked(
                bytecode,
                abi.encode(
                    _playerOne,
                    _playerTwo,
                    _token,
                    _peggedUSDToken,
                    _feesTo,
                    _betTimeStart,
                    _betTimeEnd,
                    _playerOneAmount,
                    _playerTwoAmount
                )
            );
    }
}
