// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Initialize {
    bool public _bool = true;

    function d() public {
        // delete 关键字可以是变量变为它的初始值
        delete _bool;
    }
}