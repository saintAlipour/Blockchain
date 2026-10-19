// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; 


contract TradeLogger {

address public Owner; 
event TradeLogged(string symbol,uint price,string side,uint timestamp);
constructor() {
    Owner = msg.sender;

}
modifier onlyOwner() {
    require(msg.sender == Owner,"Not Owner!");
    _;
}
function logTrade(string memory symbol,uint price,string memory side) public {
    emit TradeLogged(symbol, price, side, block.timestamp);

}
function clearLogs() public onlyOwner{

}
}

