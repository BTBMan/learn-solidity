// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ERC721.sol";

contract BTB is ERC721 {
  uint256 public constant MAX = 100; // 制作总量

  // 为 ERC721 合约设置代币的名称和符号
  constructor(
    string memory _name,
    string memory _symbol
  ) ERC721(_name, _symbol) {}

  // 铸币函数
  function mint(address to, uint256 tokenId) external {
    require(tokenId >= 0 && tokenId < MAX, unicode"token 超范围了");
    _mint(to, tokenId);
  }

  //BAYC 的 baseURI 为 ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/
  function _baseURI() internal pure override returns (string memory) {
    return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
  }
}
