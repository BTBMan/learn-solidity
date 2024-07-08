// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC165.sol";

interface IERC721 is IERC165 {
  /**
   * 转账的时候触发该事件
   * 记录代币的发出地址 {from} 和接收地址 {to} 和 {tokenId}
   */
  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );

  /**
   * 授权的时候触发该事件
   * 记录授权地址 {owner} 被授权地址 {approved} 和 {tokenId}
   */
  event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );

  /**
   * 批量授权的时候触发该事件
   * 记录批量授权发出的地址 {owner} 被授权地址 {operator} 和是否授权 {approved}
   */
  event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );

  /**
   * 用来查询某地址 NFT 持有量
   */
  function balanceOf(address owner) external view returns (uint256 balance);

  /**
   * 用来查询某个 tokenId 的主人
   */
  function ownerOf(uint256 tokenId) external view returns (address owner);

  /**
   * 普通转账 从 {from} 转给 {to} 和特定的代币 {tokenId}
   */
  function transferFrom(address from, address to, uint256 tokenId) external;

  /**
   * 安全转账, 如果接收方是合约地址, 会要求实现 ERC721Receiver 接口
   */
  function safeTransferFrom(address from, address to, uint256 tokenId) external;
  /**
   * 安全转账重载, 包涵 data
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes calldata data
  ) external;

  /**
   * 授权给 {to} 地址使用你的 NFT {tokenId}
   */
  function approve(address to, uint256 tokenId) external;

  /**
   * 查询 {tokenId} 被授权给了哪个地址
   */
  function getApprove(uint256 tokenId) external view returns (address operator);

  /**
   * 将自己持有的该系列 NFT 批量授权给 {operator} 地址
   */
  function setApprovalForAll(address operator, bool _approved) external;

  /**
   * 查询 {owner} 地址的 NFT 是否批量授权给了 {operator} 地址
   */
  function isApprovedForAll(
    address owner,
    address operator
  ) external view returns (bool);
}
