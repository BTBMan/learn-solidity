// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Store {
    // 三种不同的存储类型 storage memory calldata
    // storage 存储在链上（相当于电脑硬盘上） 操作消耗要的 gas fee 高，默认都存储在 storage 里
    // memory 临时存储在内存里 消耗 gas 少
    // calldata 临时存储在内存里 消耗 gas 少， 不可变，一般用于函数变量
    uint256[] public storageNumber = [0, 1, 2]; // 默认 storage

    function storageToStorage() public {
        uint256[] storage s1 = storageNumber;
        s1[0] = 100; // 原始变量也会变
    }

    function storageToMemory() public view {
        uint256[] memory s1 = storageNumber;
        s1[0] = 100; // 原始变量不会变
    }

    // 可以得知 storage->storage 会影响原始数据（引用）storage->memory 不会影响原始数据（副本）
    // memory->memory 会影响原始数据（引用）memory->storage 不会影响原始数据（副本）

    // 作用域
    uint256 public _number = 1; // 状态变量 存储在链上 消耗 gas 高 都可以访问
    function test() public pure returns(uint256) {
        uint256 _number2 = 2; // 局部变量 消耗 gas 低 在这里只有函数内部可以访问
        return(_number2);
    }
    // 全局变量 为 solidity 预留关键字 比如 msg.render block.number 等
}