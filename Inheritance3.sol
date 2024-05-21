// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Base1 {
    uint public n;
    
    constructor(uint x){
        n = x;
    }
}

// 继承父类 并设置 contructor 中的参数值
// 1. 在继承的时候直接传入
contract Use1 is Base1(1) {
    //
}

contract Use2 is Base1 {
    // 2. 在子合约的 constructor 后声明
    constructor(uint n) Base1(n) {
        //
    }
}