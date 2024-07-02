// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ERC20 是以太坊上的标准代币
// 实现了转账的基本逻辑

import "./IERC20.sol";

contract ERC20 is IERC20 {
  // 通过 override 修饰 public 变量, 会重写父合约中与当前变量同名的 getter 函数, 这里重写的是 balanceOf 和 allowance
  // 用来存储每个地址对应的代币数量
  mapping(address => uint256) public override balanceOf;
  // 用来存储授权者给被授权者的代币数量
  mapping(address => mapping(address => uint256)) public override allowance;

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
  function transfer(
    address to,
    uint256 amount
  ) external override returns (bool) {
    balanceOf[msg.sender] -= amount; // 调用者账户减少对应的金额
    balanceOf[to] += amount; // 接收者账户增加对应的金额

    emit Transfer(msg.sender, to, amount); // 符合触发 Transfer 事件的条件

    return true;
  }

  // 实现授权函数, 被授权者可以支配授权者 amount 数量的代币
  function approve(
    address spender,
    uint256 amount
  ) external override returns (bool) {
    allowance[msg.sender][spender] = amount;

    emit Approval(msg.sender, spender, amount); // 符合触发 Approvel 事件的条件

    return true;
  }

  // 实现 transferFrom 函数, 从授权方转一定数量的代币给接收者
  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) external override returns (bool) {
    allowance[from][msg.sender] -= amount; // 授权方减去一定数量的代币
    balanceOf[from] -= amount; // 发送方减去一定数量余额
    balanceOf[to] += amount; // 接收者增加一定数量的代币

    emit Transfer(from, to, amount); // 符合触发 Transfer 事件的条件

    return true;
  }

  // 铸币函数, 这里任何人都可以铸币, 实际当中是须要加权限的, 只有 owner 可以铸币
  function mint(uint256 amount) external {
    balanceOf[msg.sender] += amount;
    totalSupply += amount;

    emit Transfer(address(0), msg.sender, amount); // 符合触发 Transfer 事件的条件, 这里的 from 应该是个 0x00 的地址
  }

  // 销毁代币函数
  function burn(uint256 amount) external {
    balanceOf[msg.sender] -= amount;
    totalSupply -= amount;

    emit Transfer(msg.sender, address(0), amount); // 符合触发 Transfer 事件的条件, 这里的 to 应该是 0x00 的地址, 调用者销毁了 0 地址一定数量的代币
  }
}
