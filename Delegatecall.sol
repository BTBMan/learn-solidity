// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Delegatecall {
    // 委托调用
    // 通过正常的调用，用户使用合约 A 调用合约 B，那么 B 中的 msg.sender 是 A，msg.value 是 A 合约给的
    // 委托调用是用户使用合约 A 委托调用合约 B，那么 B 中的 msg.sender 是用户，msg.value 是 用户给的
    // 委托调用一般用来代理合约，将存储合约和逻辑合约分开，代理合约用来存储相关变量和逻辑合约的地址
    // 函数在逻辑合约里，通过 delegatecall 调用，当升级时只需要将代理合约指向新的合约既可
    // 另一个作用是 EIP-2535 Diamonds

    // 使用 delegatecall 的时候，要确保当前合约和目标合约的变量存储结构相同
    // 因为在使用委托调用的时候 其上下文还是调用的合约 所以被调合约内的变量不会被更改 更改的是调用合约内的变量
    // 变量名可以不同，但是类型和声明顺序必须相同
    uint public x;
    address public addr;

    event Log(bool success, bytes data);

    // delegatecall 用法和 call 大体相同，唯一不同的时只能传入 gas，不能指定 ETH
    function delegatecallSetVar(address _addr, uint _x) public payable {
        (bool success, bytes memory data) = _addr.delegatecall(
            abi.encodeWithSignature("setVar(uint256)", _x)
        );

        emit Log(success, data);
    }
    
    function callSetVar(address _addr, uint _x) public payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("setVar(uint256)", _x)
        );

        emit Log(success, data);
    }
}