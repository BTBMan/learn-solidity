// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract ValueTypes {
    bool public _bool = true; // 布尔
    // 逻辑运算符 ! && || == != 和 js 类似

    int public _int = -1; // int 整数包括负数
    uint public _uint = 1; // 正整数
    uint256 public _number = 292929; // 256 位正整数
    // 逻辑运算符和 js 类似 + - * /

    // 地址类型 存储 20 个字节的值（以太坊地址的大小）
    address public _address = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71; // 普通的地址
    address payable _address1 = payable(_address); // payable 地址类型 可以转账 查余额 多了 transfer 和 send 成员
    uint256 public balance = _address1.balance; // 查询余额

    // 定长字节数组 属于数值类型 可以存一些数据 消耗 gas 比较少
    bytes32 public _bytes32 = "MiniSolidity"; // 以子节的方式存储
    bytes1 public _byte = _bytes32[0]; // 存储 _bytes32 的第一个字节

    // 枚举
    enum ActionSet {
        Buy,
        Hold,
        Sell
    } // 和其他语音类型 默认从 0 1 2 ... 表示
    ActionSet action = ActionSet.Buy;

    // enum 可以和 uint 显士转换
    function enum2Uint() external view returns (uint) {
        return uint(action);
    }
}
