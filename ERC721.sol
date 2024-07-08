// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// EIP: Ethereum improvement proposals (以太坊改进建议), 类似 RFC
// ERC: Ethereum request for comment (以太坊意见征求稿), 用以记录以太坊应用及的各种开发标准和协议
// ERC165: 智能合约可以声明它支持的接口, 供其他合约检查, 而 ERC165 就是检查了一个合约是否支持 ERC721, ERC1155 的接口
// IERC165 接口只声明了一个函数 supportsInterface, 输入要检查的 interfaceId 接口 id, 返回 true/false
// ERC721: 用来抽象非同质化物品, 发行 NFT
// ERC721 与 ERC20 有一点区别是: ERC721 在转账授权时要明确 tokenId(代表特定的非同质化代币), 而 ERC20 只需要明确转账的数额既可
// IERC721 是 ERC721 标准的接口合约, 它继承自 IERC165

contract ERC721 {
  constructor() {}
}
