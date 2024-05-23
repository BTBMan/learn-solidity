// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Ref {
    function test() public pure {
        // memory 声明的数组必须固定长度 并且声明长度后长度不能变
        uint[] memory x1 = new uint[](3);
        // memory 必须一个一个的赋值
        x1[0]=0;
        x1[1]=1;
        x1[2]=2;
    }

    function f() public pure {
        g([uint(0), 1, 2]); // 通过第一个参数来确定数组里成员的类型 如不指定 则默认为该类型的最小单位类型
    }

    function g(uint[3] memory x2) public pure {
        //
    }
}