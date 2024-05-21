// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Base1 {
    // 可被重写的修饰符添加 virtual 关键字
    modifier isTure(uint n) virtual {
        require(n == 1);
        _;
    }
}

contract Use1 is Base1 {
    // 可以直接使用父类中的修饰符
    function getStatus(uint n) public isTure(n) pure returns(string memory){
        return "pass";
    }
}

contract Use2 is Base1 {
    // 可以通过 override 重写修饰符
    modifier isTure(uint n) override {
        require(n == 2);
        _;
    }
    
    // 可以直接使用父类中的修饰符
    function getStatus(uint n) public isTure(n) pure returns(string memory){
        return "pass";
    }
}