// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Receive {
    event Received(address sender, uint value, uint gas);
    
    // receive 函数 名称是固定的 用来处理接收的 ETH
    // 不能有参数和返回值 不能有太复杂的逻辑 避免 out of gas
    // 必须要有 external 和 payable
    receive() external payable { 
        emit Received(msg.sender, msg.value, gasleft());
    }

    // 调用合约不存在的函数时触发 可用于接收 ETH，也可以用于代理合约
    // 必须带有 external 修饰，一般也会用 payable 修饰
    fallback() external payable {
        emit Received(msg.sender, msg.value, gasleft());
    }

    // 何处触发 receive 和 fallback
    // 当有 msg.data 或者没有 receive 函数的时候触发 fallback
    // 当没有 msg.data 并且有 receive 函数的时候触发 receive

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}