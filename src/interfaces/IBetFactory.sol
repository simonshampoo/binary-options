pragma solidity 0.8.13;

interface IBetFactory {
    event BetCreated(
        address indexed playerOne,
        address indexed playerTwo,
        address tokenAddress,
        uint256 startTime,
        uint256 endTime,
        uint256 playerOneAmount,
        uint256 playerTwoAmount
    );

    event BetEnded(
        address indexed playerOne,
        address indexed playerTwo,
        address token,
        uint256 startTime,
        uint256 endTime,
        uint256 playerOneAmount,
        uint256 playerTwoAmount
    );

    // will create a new contract representing the bet between the two parties
    function createBet(
        address challengee,
        address token,
        uint256 betTimeStart,
        uint256 betTimeEnd,
        uint256 challengeeAmount
    ) external payable returns (address);

    function allBetsLength() external view returns (uint256);

    function getBetsOfAddress(address playerOne)
        external
        view
        returns (address[] memory );

    function getBetsBetweenTwoAddresses(address playerOne, address playerTwo)
        external
        view
        returns (address[] memory);
}
