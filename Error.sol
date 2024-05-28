// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Errors {
    // 也可以在合约内定义错误
    error Error2(string msg);

    function throwError(uint n) public pure {
        if (n != 1) {
            // 调用错误配合 revert
            // revert Error1("n is not equal to 1");
            revert Error1(unicode"n不等于1");
        }
    }

    function throwRequire(uint n) public pure {
        // 第一个参数为条件 第二个为描述 gas 随描述长度增加 三者中 gas 最高
        // 条件为真的时候不报错 为假的时候会报错 并展示描述
        // 也可以不添加描述
        require(n == 1, unicode"n不等于1");
    }

    function throwAssert(uint n) public pure {
        // 程序员 debug 断言
        // 条件为真的时候不报错 为假的时候会报错
        assert(n == 1);
    }
}

// 在合约之外定义错误 可以定义一个参数 也可以不定义 消耗 gas 少
error Error1(string msg);
