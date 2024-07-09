// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// EIP: Ethereum improvement proposals (以太坊改进建议), 类似 RFC
// ERC: Ethereum request for comment (以太坊意见征求稿), 用以记录以太坊应用及的各种开发标准和协议
// ERC165: 智能合约可以声明它支持的接口, 供其他合约检查, 而 ERC165 就是检查了一个合约是否支持 ERC721, ERC1155 的接口
// IERC165 接口只声明了一个函数 supportsInterface, 输入要检查的 interfaceId 接口 id, 返回 true/false
// ERC721: 用来抽象非同质化物品, 发行 NFT
// ERC721 与 ERC20 有一点区别是: ERC721 在转账授权时要明确 tokenId(代表特定的非同质化代币), 而 ERC20 只需要明确转账的数额既可
// IERC721 是 ERC721 标准的接口合约, 它继承自 IERC165

// ERC721 主合约实现了 IERC721 IERC165 IERC721Metadata 定义的所有接口

import "./IERC165.sol";
import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "./Address.sol";
import "./String.sol";

contract ERC721 is IERC721, IERC721Metadata {
  using Address for address; // 使用 Address 库, 用 isContract 判断地址是否是合约
  using Strings for uint256; // 使用 String 库

  string public override name; // Token 名称
  string public override symbol; // Token 代号
  mapping(uint => address) private _owner; // tokenId 对应的持有人 map
  mapping(address => uint) private _balance; // address 对应的持仓数量 map
  mapping(uint => address) private _tokenApprovals; // tokenId 对应的授权地址 map
  mapping(address => mapping(address => bool)) private _operatorApprovals; // owner 地址到 operator 地址的批量授权 map

  // 初始化 name 和 symbol
  constructor(string memory _name, string memory _symbol) {
    name = _name;
    symbol = _symbol;
  }

  /**
   * 实现 supportsInterface, 查询是否实现了指定的接口
   */
  function supportsInterface(
    bytes4 interfaceId
  ) external pure override returns (bool) {
    return
      interfaceId == type(IERC721).interfaceId ||
      interfaceId == type(IERC165).interfaceId ||
      interfaceId == type(IERC721Metadata).interfaceId;
  }

  /**
   * 查询 owner 地址的余额
   */
  function balanceOf(address owner) external view override returns (uint) {
    require(owner != address(0), unicode"不能查询铸币地址");
    return _balance[owner];
  }

  /**
   * 实现查询 tokenId 的 owner
   */
  function ownerOf(uint tokenId) public view override returns (address) {
    address owner = _owner[tokenId];
    require(owner != address(0), unicode"token 不存在");
    return owner;
  }

  /**
   * 实现查询 owner 地址是否将所持有的 NFT 批量授权给了 operator
   */
  function isApprovedForAll(
    address owner,
    address operator
  ) external view override returns (bool) {
    return _operatorApprovals[owner][operator];
  }

  /**
   * 实现将持有代币全部授权给 operator 地址
   * 调用者 msg.sender 将代币授权给 operator
   */
  function setApprovalForAll(
    address operator,
    bool _approved
  ) external override {
    _operatorApprovals[msg.sender][operator] = _approved;
    emit ApprovalForAll(msg.sender, operator, _approved); // 触发对应的事件
  }

  /**
   * 实现查询 tokenId 的授权地址
   */
  function getApprove(uint tokenId) external view override returns (address) {
    require(_owner[tokenId] != address(0), unicode"token 不存在");
    return _tokenApprovals[tokenId];
  }

  /**
   * 实现授权函数, 调用者 msg.sender 将 tokenId 授权给 to 地址
   * 条件:
   * to 不能是 owner (表示此前 tokenId 没有被授权给 to 过)
   * 当前调用者 msg.sender 是 owner (表示当前调用者持有当前 tokenId 才有授权给别人的条件)
   * 或者当前调用者是被授权地址 (表示 tokenId 的 owner 此前授权给当前调用者过, 所以当前调用者才有授权给别人的条件)
   */
  function approve(address to, uint tokenId) external override {
    // 获取当前 tokenId 的 owner
    address owner = _owner[tokenId];

    require(
      owner != to &&
        (msg.sender == owner || _operatorApprovals[owner][msg.sender]),
      unicode"您暂无授权条件"
    );
  }

  /**
   * 授权函数, 方便复用
   */
  function _approve(address owner, address to, uint tokenId) private {
    _tokenApprovals[tokenId] = to; // 授权 to 地址操作 tokenId
    emit Approval(owner, to, tokenId); // 触发事件
  }
}
