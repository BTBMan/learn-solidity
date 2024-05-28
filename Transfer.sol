// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Transfer {
    // payable 使得部署的时候可以转 ETH 进去
    // 如果没有 payable 则在部署的时候是不能转进 ETH 的
    constructor() payable {}

    // 接收 ETH 的时候被触发
    receive() external payable { }

    // 自定义错误
    error SendFailed();
    error CallFailed();

    function transferETH(address payable to, uint256 value) external payable{
        // 发送发地址调用 transfer 函数 参数为发送的 ETH 数额
        // 发送失败会回滚交易
        // gas limit 是 2300 fallback 和 receive 不能有复杂的逻辑
        to.transfer(value);
    }

    function sendETH(address payable to, uint256 value) external payable{
        // 发送发地址调用 send 函数 参数为发送的 ETH 数额 返回交易是否成功的状态
        // 发送失败不会回滚交易 须要手动处理
        // gas limit 是 2300 fallback 和 receive 不能有复杂的逻辑
        bool success = to.send(value);
        if (!success) {
            revert SendFailed();
        }
    }

    function callETH(address payable to, uint256 value) external payable{
        // 发送发地址调用 call 函数 value 参数为发送的 ETH 数额 返回交易是否成功的状态和 data
        // 发送失败不会回滚交易 须要手动处理
        // 没有 gas limit 支持接收方 fallback 和 receive 有复杂的逻辑
        (bool success,) = to.call{value: value}("");
        if (!success) {
            revert CallFailed();
        }
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    // 转账时注意合约里的金额要 >= 要转账的金额 不满足则会交易失败
}