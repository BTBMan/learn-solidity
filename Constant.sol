// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Constant {
    // 使用 constant 关键字定义常量，一旦定义后就不可以修改了，如果尝试修改则不会编译通过
    // constant 必须在声明时就初始化
    uint constant C_NUM = 10;
    // immutable 可以在声明时和函数中初始化
    uint immutable C_NUM2 = 10; // 只有数值可以设置 immutable 和 constant

    string constant C_STRING = "xxx"; // string 和 bytes 不可以设置为 immutable
}