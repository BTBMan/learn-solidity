// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 抽象合约
abstract contract Ab1 {
    // 如果合约里有一个未实现实体的函数 也就是函数没有{} 则合约使用 abstract 关键字修饰
    // 须要继承的子合约实现这个函数 则这个函数必须加上 virtual 关键字 没有实体的函数必须标有 virtual
    function do1(uint n) public pure virtual;

    function do2(uint n) public pure{
        //
    }
}

// 实现抽象
contract Use1 is Ab1 {
    function do1(uint n) public pure override {
        //
    }
}

contract MainContract {
    Use1 public use1;

    constructor() {
        use1 = new Use1();
    }

    function call() public view {
        use1.do1(1);
    }
}

// 接口定义
// 就是 ts 中类型 不实现功能 只标注每个函数或实现类型 参数类型
// 不能包括状态变量
// 函数必须是 external
interface T1 {
    event E1(string msg);
    
    function do1(uint n) external pure returns(uint x);
}

// 接口只能继承接口 不能继承合约
interface T2 is T1 {
    //
}