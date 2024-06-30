// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 简单的 Uniswap

// 币对合约，用来管理币对地址
contract Pair {
    address public factory; // 工厂合约地址
    address public tokenA; // 代币 tokenA 地址
    address public tokenB; // 代币 tokenB 地址

    // payable 的合约
    constructor() payable {
        factory = msg.sender; // 存储工厂合约地址
    }

    function initialize(address _tokenA, address _tokenB) external {
        require(msg.sender == factory, unicode"初始化的合约地址必须是和创建 Pari 的合约地址是同一个工厂合约");
        tokenA = _tokenA;
        tokenB = _tokenB;
    }
}

// 工厂合约
contract FactoryPair {
    // 通过两个代币地址查 Pair 地址
    mapping(address => mapping(address => address)) public getPair;
    // 存储所有 Pair 地址
    address[] public allPairs;

    // 创建币对地址
    function createPair(address tokenA, address tokenB) external returns(address pairAddr)  {
        // 创建币对合约
        Pair pair = new Pair();
        // 调用真正的初始化方法
        pair.initialize(tokenA, tokenB);

        // 存储 Pair 地址到集合
        pairAddr = address(pair);
        allPairs.push(pairAddr);

        // 添加代币地址 map
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }
}