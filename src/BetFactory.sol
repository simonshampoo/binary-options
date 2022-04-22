pragma solidity 0.8.11;

import './interfaces/IBetFactory.sol';

contract BetFactory is IBetFactory {

    struct Bet {
        address partyOne; 
        address partyTwo; 
        uint256 payoff; 
        uint256 priceAtBetSubmission; 
        uint256 startTime; 
        uint256 endTime; 
    }

    address public feesTo;



    event BetCreated(
        address indexed longer,
        address indexed shorter,
        address indexed token,
        uint256 indexed beginTime,
        uint256 indexed endTime,
        uint256 amount
    );

    function getBetsBetweenTwoAddresses(address longer, address shorter)
        public
        view
        returns (address[])
    {
        return address(0);
    }
}
