
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
//import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";
import {Ownable} from "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract AzarsAuditLog is Ownable {
    mapping (address => bool) public authLoggers;
    uint256 public logCount;
    event TradeLogged(
        address indexed logger,
        string symbol,
        uint256 price,
        string side,
        uint256 timestamp,
        uint256 indexed logId
    );
    event LoggerAuthorized(address indexed  logger);
    event LoggerRevoked(address indexed logger);

    modifier  onlyLogger(){
       if (!authLoggers[msg.sender]){
        revert UnauthorizedLogger(msg.sender);

       }
        _;

    }
    error UnauthorizedLogger(address caller);
    error InvalidSide (string side);
    error EmptySymbol();
constructor(address initialOwner) Ownable(initialOwner) {}

    function addLogger(address _logger) external onlyOwner {
        authLoggers[_logger] = true;
        
        emit LoggerAuthorized(_logger);
    }
 function removeLogger(address _logger) external onlyOwner {
   authLoggers[_logger] = false ;
   emit LoggerRevoked(_logger);
 }
 
function logTrade(string calldata symbol,uint256 price,string calldata side, uint256 timestamp) external onlyLogger returns (uint256)
{
    if (bytes(symbol).length==0){
        revert EmptySymbol();
    }
    if (
    keccak256(abi.encodePacked(side)) != keccak256(abi.encodePacked("BUY")) &&
    keccak256(abi.encodePacked(side)) != keccak256(abi.encodePacked("SELL"))
) {
    revert InvalidSide(side);
}
logCount++;
emit TradeLogged(msg.sender, symbol, price, side, timestamp, logCount);

return logCount;
    
}
}