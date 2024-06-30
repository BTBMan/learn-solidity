// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract OtherContract {
    // payable 表示部署时可以接收 ETH
    constructor() payable {}
    
    uint256 private x = 0;

    // 定义一个 log 事件
    event Log(uint amount, uint gas);

    // 在其他合约中调用当前合约内部不存在的函数时会执行这个 fallback 函数
    fallback() external payable {}

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    // 设置 x 的值
    function setX(uint256 v) external payable {
        x = v;

        // 如果有传入 ETH 则触发 Log 事件
        if (msg. value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns(uint256) {
        return x;
    }
}