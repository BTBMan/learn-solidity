// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 文件的相对位置进行导入
// 可以通过 import 关键字导入其他合约 也可以导入 http 地址和 npm 包地址
// import 'xxx' 不用具名导入也可以
// 和 js 一个样 xx as xx * as xx 具名 全量
// 可以引用其他文件中的合约和函数和结构体 或导入别人写好的代码
import {Yeye} from './Inheritance.sol';

contract Import {
    Yeye yeye = new Yeye();

    function do1() public {
        yeye.hip();
    }
}