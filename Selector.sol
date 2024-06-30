// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Selector {
    event Log(bytes data);

    function mint(uint8 x) external {
        // msg.data 其实是 calldata
        // 包涵了调用了哪个函数以及函数的参数是什么
        // 控制台中的 input 字段指定了一个 16 进制的字符
        // 0x6ecd23060000000000000000000000000000000000000000000000000000000000000001
        // 前 4 个字节为函数选择器 0x6ecd2306 => mint(uint8)
        // 后面 32 个字节为输入的参数
        emit Log(msg.data);
    }

    function fnSelector() public pure returns(bytes4 s){
        // 基础类型的函数签名
        // fn(uint x, bool s) => fn(uint,bool) uint int 须要写为 uint256 int256
        
        // 固定长度类型
        // fn(uint[2] x) => fn(uint[2])

        // 可变长度类型
        // fn(uint[] x, string s) => fn(uint[],string)

        // 映射类型
        // Contract A {}
        // struct B {uint n; bytes d}
        // enum C {a, b, c}
        // fn(A a, B memory b, C c) => fn(address,(unit,bytes),uint8)
        s = bytes4(keccak256("transfer(address,uint256)"));
    }
}