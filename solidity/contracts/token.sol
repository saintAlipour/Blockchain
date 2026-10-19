// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Token 
{
string public name ="edwin";
string public symbol="Blue";    
uint8 public decimals = 18;
uint256 public totalSupply;
address public owner;

mapping(address => uint256) public balanceOf;
mapping(address=>mapping (address => uint256)) public allowance;

event Transfer(address from,address to,uint256 value);
event Approval(address owner,address spender,uint256 value);

modifier onlyOwner(){
    require(msg.sender == owner, "not owner");
    _;
}

constructor(uint256 _initialSupply) {
    owner = msg.sender;
    totalSupply = _initialSupply *10 ** uint256 (decimals);
    balanceOf[msg.sender] = totalSupply;
    emit Transfer(address(0),msg.sender,totalSupply);

}
function transfer(address _to , uint256 _value) public returns (bool) {
require(_to != address(0),"invalid address");
require((balanceOf[msg.sender] >= _value),"insufficient balance");

balanceOf[msg.sender] -= _value;
balanceOf[_to] += _value;
emit Transfer(msg.sender, _to, _value);
return true;
}

}