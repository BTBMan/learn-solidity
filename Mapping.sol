// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Mapping {
    // 隐射的存储位置必须是 storage
    // 不能用于 public 函数的参数中和返回结果中
    mapping(uint => address) public idToAddress; // 初始值都是各个 type 的默认值 address 默认为 0x0000000000000000000000000000000000000000
    mapping(uint => uint) public idToId; // uint 默认的初始值为 0

    function set(uint key, uint val) public {
        idToId[key] = val;
    }
}