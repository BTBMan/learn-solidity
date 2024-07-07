// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";

// 空投合约
contract Airdrop {
  constructor() {}

  // 获取空投数量总数
  function getSum(uint256[] calldata arr) public pure returns (uint256 sum) {
    for (uint256 i = 0; i < arr.length; i++) {
      sum += arr[i];
    }
  }

  // 发送 ERC20 代币空投
  function multiTransferToken(
    address tokenAddr,
    address[] calldata addresses,
    uint256[] calldata amount
  ) external {
    require(
      addresses.length == amount.length,
      unicode"接收地址数量和总发送数量长度必须相等"
    );

    IERC20 token = IERC20(tokenAddr); // 声明 IERC20 合约变量
    uint256 amountSum = getSum(amount); // 计算空投代币总数量

    require(
      token.allowance(msg.sender, address(this)) >= amountSum,
      unicode"当前调用者授权给这个空投合约的代币数量必须大于空投代币总数量"
    );

    // 利用 for 批量发送空投
    for (uint256 i = 0; i < addresses.length; i++) {
      // 把调用者 ??
      token.transferFrom(msg.sender, addresses[i], amount[i]);
    }
  }

  // 发送 ETH 空投
  function multiTransferETH(
    address[] calldata addresses,
    uint256[] calldata amount
  ) external payable {
    require(
      addresses.length == amount.length,
      unicode"接收地址数量和总发送数量长度必须相等"
    );

    uint256 amountSum = getSum(amount); // 计算空投 ETH 总数量

    require(
      msg.value == amountSum,
      unicode"当前调用者传入的 ETH 的数量必须大于空投 ETH 总数量"
    );

    // 利用 for 批量发送空投
    for (uint256 i = 0; i < addresses.length; i++) {
      // 给每个地址利用 call 转账一定数量的 ETH
      (bool success, ) = addresses[i].call{value: amount[i]}("");

      if (!success) {
        // 失败逻辑...
      }
    }
  }
}

// ERC20 代币空投具体步骤:
// 先部署一个发送代币的 ERC20 的合约地址
// 使用当前账户给 ERC20 地址 mint 1000 个代币, 此时 ERC20 合约里存储了当前账户有 1000 个代币
// 部署空投合约
// 利用 ERC20 合约中的 approve 函数给空投合约授权 1000 个代币
