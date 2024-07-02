// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC20.sol";

// ERC20 水龙头
contract Faucet {
  uint256 public amountAllowed = 100; // 每次最大领取代币数量
  address public tokenContract; // 发送代币的合约地址
  mapping(address => bool) public requestedAddress; // 记录领取过的地址

  event SendToken(address indexed to, uint256 indexed amount); // 定义发送代币的事件

  constructor(address _tokenContract) {
    // 初始化发送代币的地址
    tokenContract = _tokenContract;
  }

  // 领取代币函数
  function requestToken() external {
    require(!requestedAddress[msg.sender], unicode"每个地址只能领取一次");
    IERC20 token = IERC20(tokenContract); // 创建了一个 ERC20 合约对象, 方便调用

    require(
      token.balanceOf(address(this)) >= amountAllowed,
      unicode"水龙头空了"
    );

    token.transfer(msg.sender, amountAllowed); // 给调用者发送指定数量的代币
    requestedAddress[msg.sender] = true; // 记录领取的地址

    emit SendToken(msg.sender, amountAllowed); // 触发发送代币事件
  }
}

// 具体步骤:
// 先部署一个发送代币的 ERC20 的合约地址
// 使用当前账户给 ERC20 地址 mint 1000 个代币, 此时 ERC20 合约里存储了当前账户有 1000 个代币
// 部署水龙头合约, 并填上 ERC20 的合约的地址初始化为发送代币的合约
// 使用当前账户调用 ERC20 合约转账给水龙头 1000 个代币, 此时 ERC20 合约里存储了当前账户为 0, 而水龙头合约有 1000 个代币
// 换一个账户, 调用水龙头的 requestToken 方法领取代币, 此时 ERC20 合约里存储了领取的账户为 100, 而水龙头合约减少了 100 个代币
// 当前领取的地址被记录为已领取, 不可再次领取了
