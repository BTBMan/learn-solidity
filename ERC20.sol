// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ERC20 是以太坊上的标准代币
// 实现了转账的基本逻辑

import './IERC20.sol';

abstract contract ERC20 is IERC20 {
  // 通过 override 修饰 public 变量, 会重写父合约中与当前变量同名的 getter 函数, 这里重写的是 balanceOf 和 allowance
  mapping (address => uint256) public override balanceOf;
  mapping (address => mapping(address => uint256)) public override allowance;

  // 代币总供给
  uint256 public override totalSupply;
  // 代币名称
  string public name;
  // 代币代号
  string public symbol;
  // 小数位数, 由于智能合约中没有小数, 所以有变量代表小数
  uint8 public decimals = 8;

  constructor(string memory _name, string memory _symbol) {
    // 创建合约时初始化代币的名称和代号
    name = _name;
    symbol = _symbol;
  }

  // 实现转账, 调用者转账给 to 账户 amount 数量代币
  function transfer(address to, uint256 amount) external override returns(bool) {
    balanceOf[msg.sender] -= amount; // 调用者账户减少对应的金额
    balanceOf[to] += amount; // 接收者账户增加对应的金额

    emit Transfer(msg.sender, to, amount); // 符合触发 Transfer 事件的条件

    return true;
  }
}