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
  mapping(uint => address) private _owners; // tokenId 对应的持有人 map
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
    address owner = _owners[tokenId];
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
    require(_owners[tokenId] != address(0), unicode"token 不存在");
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
    address owner = _owners[tokenId];

    require(
      owner != to &&
        (msg.sender == owner || _operatorApprovals[owner][msg.sender]),
      unicode"您暂无授权条件"
    );

    _approve(owner, to, tokenId);
  }

  /**
   * 授权函数, 方便复用
   */
  function _approve(address owner, address to, uint tokenId) private {
    _tokenApprovals[tokenId] = to; // 授权 to 地址操作 tokenId
    emit Approval(owner, to, tokenId); // 触发事件
  }

  /**
   * 实现非安全转账
   * 从 {from} 转给 {to} 的 {tokenId}
   */
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external override {
    address owner = ownerOf(tokenId);

    require(
      _isApprovedOrOwner(owner, msg.sender, tokenId),
      unicode"调用者即不是 owner 也不是被授权的地址"
    );

    _transfer(owner, from, to, tokenId);
  }

  /**
   * 转账函数
   * 从 {from} 转账给 {to} 的 {tokenId}
   * 要求:
   * 1. from 是 tokenId 的拥有者
   * 2. to 不能是 0 地址
   */
  function _transfer(
    address owner,
    address from,
    address to,
    uint256 tokenId
  ) private {
    require(to != address(0), unicode"不能转账给 0 地址");
    require(from == owner, unicode"出账用户不是 tokenId 的拥有者");

    // 调用这个函数的作用是:
    // 由于把 tokenId 从 from 转账给 to, 这里的 from 则为 owner
    // 所以转账后 owner 也发生改变, 由原来的 from 变为 to
    // 那么原 owner 授权过的地址应该归 0
    _approve(owner, address(0), tokenId);

    _balance[from] -= 1;
    _balance[to] += 1;
    _owners[tokenId] = to; // 由于把 tokenId 从 from 转账给 to, 所以 tokenId 的拥有者也变为 to 了

    emit Transfer(from, to, tokenId); // 触发对应事件
  }

  /**
   * 查询 {spender} 是否为 {owner}
   * 或 {tokenId} 是否被授权给 {spender} 账户 _tokenApprovals
   * 或 {owner} 是否批量授权给 {spender} _operatorApprovals
   */
  function _isApprovedOrOwner(
    address owner,
    address spender,
    uint256 tokenId
  ) private view returns (bool) {
    return
      spender == owner ||
      _tokenApprovals[tokenId] == spender ||
      _operatorApprovals[owner][spender];
  }

  /**
   * 实现安全转账
   */
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) public override {
    // 前置判断和普通转账一样
    address owner = ownerOf(tokenId);

    require(
      _isApprovedOrOwner(owner, msg.sender, tokenId),
      unicode"调用者即不是 owner 也不是被授权的地址"
    );

    _safeTransfer(owner, from, to, tokenId, data);
  }

  /**
   * 安全转账重载
   */
  function safeTransferFrom(
    address from,
    address to,
    uint tokenId
  ) external override {
    safeTransferFrom(from, to, tokenId, "");
  }

  /**
   * 安全转账函数
   */
  function _safeTransfer(
    address owner,
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) private {
    _transfer(owner, from, to, tokenId);

    // 多验证是否支持 IERC721Receiver-onERC271Received, 没有实现则回滚交易
    require(
      _onCheckOnERC721Received(from, to, tokenId, data),
      unicode"没有实现 onERC721Received 方法"
    );
  }

  /**
   * 检查合约是否支持 IERC721Receiver-onERC271Received 函数
   * to 为合约的时候才检查
   */
  function _onCheckOnERC721Received(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  ) private returns (bool) {
    // 是合约走验证
    if (to.isContract()) {
      // 通过 IERC721Receiver 包裹合约并调用合约内部的 onERC721Received 方法
      return
        IERC721Receiver(to).onERC271Received(msg.sender, from, tokenId, data) ==
        IERC721Receiver.onERC271Received.selector; // 详见函数选择器了解更多 https://www.wtf.academy/docs/solidity-102/Selector/
    } else {
      return true;
    }
  }

  /**
   * 铸币函数 调整 _balance 和 _owners 铸造 {tokenId} 并转账给 {to}
   * 函数必须支持重写
   * 将要铸造的 tokenId 没有被铸造过
   * to 不能是 0 地址
   * 触发 Transfer 事件
   */
  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), unicode"转账地址不可以是 0 地址");
    require(_owners[tokenId] == address(0), unicode"代币已经被铸造过");

    _balance[to] += 1;
    _owners[tokenId] = to;

    emit Transfer(address(0), to, tokenId); // 铸币是 0 地址
  }

  /**
   * 销毁函数 销毁 {tokenId}
   * tokenId 必须存在
   * 当前调用者必须是 owner
   * 触发 Trqnsfer 事件
   */
  function _burn(uint256 tokenId) internal virtual {
    address owner = _owners[tokenId];
    require(owner != address(0), unicode"tokenId 不存在");
    require(msg.sender == owner, unicode"调用者不是该 token 的持有者");

    _approve(owner, address(0), tokenId); // 删除之前的授权数据, 和转账的操作一样
    _balance[owner] -= 1; // owner 的余额 -1
    delete _owners[tokenId]; // 删除 tokenId 对应的拥有者

    emit Transfer(owner, address(0), tokenId);
  }

  /**
   * 实现 IERC721Metadata 中的 tokenURI 函数, 查询 metadata
   * 支持重写
   */
  function tokenURI(
    uint256 tokenId
  ) public view virtual override returns (string memory) {
    require(_owners[tokenId] != address(0), unicode"tokenId 不存在");

    string memory baseURI = _baseURI();

    return
      bytes(baseURI).length > 0
        ? string(abi.encodePacked(baseURI, tokenId.toString())) // 把 tokenURI 和 tokenId 打包
        : "";
  }

  /**
   * 计算 tokenURI
   * 须要支持重写
   */
  function _baseURI() internal view virtual returns (string memory) {
    return "";
  }
}
