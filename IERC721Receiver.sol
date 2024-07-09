// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// ERC721 合约的 safeTransferFrom 函数须要对方合约实现 ERC721Receiver 接口, 避免转账进入黑洞
interface IERC721Receiver {
  function onERC271Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) external returns (bytes4);
}
