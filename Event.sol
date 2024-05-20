// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Event {
    // 事件通过订阅监听 在前端响应

    // 记录了三个变量 indexed 用来把数据存在以太坊虚拟机的日志的 topics 中，方便日后检索 最多 3 个 每个固定动效 256 比特
    // 不带 indexed 的参数会被保存在 data 中 不能被检索 消耗的 gas 比 topic 少
    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping(address => uint256) public _balances;

    function doTransfer(address from, address to, uint256 amount) public {
        _balances[from] = 1000000000;

        _balances[from] -= amount;
        _balances[to] += amount;

        // 触发事件
        emit Transfer(from, to, amount);
    }
}