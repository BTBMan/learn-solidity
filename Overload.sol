// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Overload {
    // 两个相同的函数 参数或返回值不同 就会形成重载
    function do1() public pure returns(string memory){
        return "hello";
    }
    function do1(string memory s) public pure returns(string memory){
        return s;
    }

    // 这种情况调用 do2 会报错 原因是在调用函数时 和把实际参数和参数类型进行匹配 如果有多个匹配 则会报错
    // 比如 do2(50) 50 既可以转换为 uint8 也可以转换为 uint256
    function do2(uint8 n) public pure returns(uint){
        return n;
    }
    function do2(uint256 n) public pure returns(uint){
        return n;
    }
}