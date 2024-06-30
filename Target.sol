// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Target {
    uint public x;
    address public addr;

    function setVar(uint v) public payable {
        x = v;
        addr = msg.sender;
    }
}


