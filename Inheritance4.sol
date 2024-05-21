// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 钻石继承 菱形继承
contract Nothing {
    event Log(string msg);

    function hip() public virtual {
        emit Log("Nothing");
    }
    
    function hop() public virtual {
        emit Log("Nothing");
    }
}

contract Yeye is Nothing {
    function hip() public virtual override {
        emit Log("Yeye");
        super.hip();
    }
    
    function hop() public virtual override {
        emit Log("Yeye");
        super.hop();
    }
}

contract Baba is Nothing {
    function hip() public virtual override {
        emit Log("Baba");
        super.hip();
    }

    function hop() public virtual override {
        emit Log("Baba");
        super.hop();
    }
}

contract Erzi is Yeye, Baba {
    function hip() public override(Yeye, Baba) {
        // 调用 hip 函数 会一次调用 Baba 下的 hip 和 Yeye 中的 hip 最后只调用一次 Nothing 中的 hip
        super.hip();
    }

    function hop() public override(Baba, Yeye ) {
        // 同上
        super.hop();
    }
}