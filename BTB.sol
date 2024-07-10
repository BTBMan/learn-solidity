// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "ERC721.sol";

contract BTB is ERC721 {
  uint256 public constant MAX = 100; // 制作总量

  // 为 ERC721 合约设置代币的名称和符号
  constructor(
    string memory _name,
    string memory _symbol
  ) ERC721(_name, _symbol) {}
}
