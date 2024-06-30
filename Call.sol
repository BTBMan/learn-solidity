// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Call {
    // 定义一个响应事件
    event Response(bool success, bytes data);

    // 使用 call 来调用其他合约函数中的 setX 函数
    function callSetX(address payable addr, uint256 x) public payable {
        (bool success, bytes memory data) = addr.call{value: msg.value}(
            abi.encodeWithSignature("setX(uint256)", x) // 使用 abi.encodeWithSignature 的时候须要传入要调用的函数名和函数参数类型 第二个为函数参数的值
        );

        // 触发事件
        emit Response(success, data);
    }

    // 调用 getX
    function callGetX(address payable addr) public returns(uint256) {
        (bool success, bytes memory data) = addr.call(
            abi.encodeWithSignature("getX()") // 使用 abi.encodeWithSignature 的时候须要传入要调用的函数名和函数参数类型 第二个为函数参数的值
        );

        // 触发事件
        emit Response(success, data);
        return abi.decode(data, (uint256));
    }

    // 调用一个不存在的函数
    function callNonExist(address _addr) external{
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("foo(uint256)")
        );

        emit Response(success, data);
    }
}