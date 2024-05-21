// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Yeye {
    event Log(string msg);

    // 如果希望子合约重写 则加上 virtual 关键字
    function hip() public virtual {
        emit Log("Yeye");
    }
    
    function hop() public virtual {
        emit Log("Yeye");
    }

    function yeye() public virtual {
        emit Log("Yeye");
    }

    function callYeye() public {
        emit Log("Yeye");
    }
}

// 通过 is 去继承父类
contract Baba is Yeye {
    // 通过 override 关键字去重写父类的方法
    // 如果用 override 去修饰变量 则会重写变量的同名 getter 函数
    function hip() public virtual override {
        emit Log("Baba");
    }

    function hop() public virtual override {
        emit Log("Baba");
    }

    function baba() public virtual {
        emit Log("Baba");
    }

    function callBaba() public {
        emit Log("Baba");
    }
}

// 可以继承多个父类 用逗号隔开 从辈份高到低排列
// 如果一个函数在多个继承的合约里都存在 比如 hip 和 hop，则必须在子合约里重写 不然会报错
contract Erzi is Yeye, Baba {
    // 重写多个父类都重名的方法 必须在 override 里指定父合约的名子
    function hip() public virtual override(Yeye, Baba) {
        emit Log("Erzi");
    }

    function hop() public virtual override(Baba, Yeye ) {
        emit Log("Erzi");
    }

    function erzi() public virtual {
        emit Log("Erzi");
    }

    function say() public {
        // 直接通过合约名调用父类的方法
        Yeye.callYeye();

        // 通过 super 调用最近的父类方法 从右到左 Baba->Yeye
        super.hip(); // Baba
    }
}