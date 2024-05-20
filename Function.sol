// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Function {
    // 关键字    函数名 参数      可见性    权限/功能  返回的变量类型和名称
    // function fn1(int param) external view      returns(uint)
    // 可见性：public-内外都可见 private-只能内部访问，继承的也不能用 external-只能外部访问，可以用 this.xx() 来调用 internal-只能内部访问，继承的也可以访问
    // 没标明函数可见性默认 public
    // public private internal 也可以修饰函数参数 public 会自动生成同名 getter 用来查询数值
    // 没标明变量可见性默认 internal
    // 函数权限/功能：payable-可支付 pure-纯函数 不能对合约里的状态进行读写 view-只能查看合约里的状态 不能写入 什么都没有的函数可以读写
    // 为什么会有这些权限？因为合约里的状态变量是存在链上的 每次操作链上的状态会消耗昂贵的 gas fee，调用任何未标记 view 和 pure 的函数就视为修改链上的状态
    int256 public _number = 1;
    function add() external {
        _number += 1;
    }

    // 用 pure 通过变量传递做返回值
    function addPure(int256 _n) external pure returns(int256 new_number) {
        new_number = _n + 5;
    }

    // 用 view 读后返回值
    function addView() external view returns(int256 new_number) {
        new_number = _number + 5;
    }

    // 内部函数 只能合约内部调用
    function addInternal() internal {
        _number = _number + 1;
    }

    // 合约内的函数可以调用内部的函数
    function addCall() external {
        addInternal();
    }

    // 输出 returns 表明返回的类型和变量名 函数内通过指定的变量名赋值后自动返回
    function return1() public pure returns(uint256 _uint, bool _bool) {
        _uint = 8;
        _bool = true;
    }

    // 通过 return 关键字返回
    function return2() public pure returns(uint256 _uint, bool _bool) {
        return(9, true);
    }

    function readReturn() public pure returns(uint256 _uint, bool _bool) {
        // 解构赋值
        _uint;
        _bool;

        (_uint, _bool) = return1();
    }

}