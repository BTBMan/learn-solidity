// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Constructor {
    address public owner;
    
    // 就是 class 中的 constructor
    constructor() {
        owner = msg.sender;
    }

    // 修饰符
    modifier onlyOwner {
        require(msg.sender == owner); // 检查运行函数的人（msg.sender）是不是 owner（自己）
        _; // 是的话，继续运行函数主体，否则报错并 revert 交易
    }

    function changeOwner(address _newOwner) public onlyOwner{
        owner = _newOwner;
    }
}