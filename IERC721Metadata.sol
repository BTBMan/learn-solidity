// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC721.sol";

// 为 IERC721 的拓展接口, 实现了查询 metadata 元数据常用函数
interface IERC721Metadata is IERC721 {
  function name() external pure returns (string memory);

  function symbol() external pure returns (string memory);

  /**
   * 根据 tokenId 查询 metadata 的链接 URI
   */
  function tokenURI(uint256 tokenId) external view returns (string memory);
}
