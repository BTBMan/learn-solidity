// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 被调合约
contract OtherContract2 {
    uint256 private x = 0;

    event Log(uint amount, uint gas);

    // 获取合约 ETH 余额
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function setX(uint256 _x) external payable {
        x = _x;

        // 如果有转入 ETH 则触发 Log 事件
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns(uint){
        return x;
    }

}