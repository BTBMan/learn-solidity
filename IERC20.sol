// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// IERC20 为 ERC20 的接口, 规定了实现代币的函数和事件
// IERC20 定义了 6 个函数, 提供了转移代币的基本功能, 以便其他链上第三方调用
// IERC20 定义了 2 个事件, 分别在转账和授权时触发

interface IERC20 {
  /**
   * @dev 释放条件：当 `value` 单位的货币从账户 (`from`) 转账到另一账户 (`to`) 时.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev 释放条件：当 `value` 单位的货币从账户 (`owner`) 授权给另一账户 (`spender`) 时.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);

  /**
   * @dev 返回代币总供给.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev 返回账户`account`所持有的代币数.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev 转账 `amount` 单位代币，从调用者账户到另一账户 `to`.
   * 如果成功，返回 `true`.
   * 释放 {Transfer} 事件.
   */
  function transfer(address to, uint256 amount) external returns (bool);

  /**
   * @dev 返回`owner`账户授权给`spender`账户的额度，默认为 0。
   * 当 {approve} 或 {transferFrom} 被调用时，`allowance`会改变.
   */
  function allowance(
    address owner,
    address spender
  ) external view returns (uint256);

  /**
   * @dev 调用者账户给`spender`账户授权 `amount`数量代币。
   * 如果成功，返回 `true`.
   * 释放 {Approval} 事件.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev 通过授权机制，从`from`账户向`to`账户转账`amount`数量代币。转账的部分会从调用者的`allowance`中扣除。
   * 如果成功，返回 `true`.
   * 释放 {Transfer} 事件.
   */
  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) external returns (bool);
}
