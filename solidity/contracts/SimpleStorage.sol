// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    uint256 public storedValue;
    event ValueChanged(uint256 newValue);

    function set(uint256 _value) public {
        require(_value > 0, "Value must be greater than zero");
        storedValue = _value;
        emit ValueChanged(_value);
    }
}

