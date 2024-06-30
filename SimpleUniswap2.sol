// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 简单的 Uniswap2 利用 create2 实现

// create2 作用
// 可以在部署之前预测合约的地址

// create2 如何计算地址
// 0xff 一个常数，避免与 create 冲突
// CreatorAddress 当前调用者的合约地址
// salt 盐 影响新创建的合约地址
// initCode 合约的初始字节码 （合约的 creationCode 和构造函数参数）
// 公式 hash(0xff, "创建者地址", salt, initCode)

// create 如何计算地址
// CreatorAddress 当前调用者的合约地址
// nonce 随机数，这里使用的是该地址的交易总数 or 创建合约的总数 因为 nonce 会变，所以合约地址不好预测
// 公式 hash("创建者地址", nonce)

// create2 的实际应用场景：
// 交易所为新用户预留创建钱包的合约地址
// Router 中可以计算地址

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
contract PairFactory2 {
    // 通过两个代币地址查 Pair 地址
    mapping(address => mapping(address => address)) public getPair;
    // 存储所有 Pair 地址
    address[] public allPairs;

    // 创建币对地址
    function createPair(address tokenA, address tokenB) external returns(address pairAddr)  {
        require(tokenA != tokenB, unicode"tokenA 和 tokenB 不能相同");
        // 用两个进行升序排序的 token 计算 salt
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        // 计算的 salt 为 tokenA 和 tokenB 的 hash
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        // 创建币对合约 填入 salt
        Pair pair = new Pair{salt: salt}();
        // 调用真正的初始化方法
        pair.initialize(tokenA, tokenB);

        // 存储 Pair 地址到集合
        pairAddr = address(pair);
        allPairs.push(pairAddr);

        // 添加代币地址 map
        getPair[tokenA][tokenB] = pairAddr;
        getPair[tokenB][tokenA] = pairAddr;
    }

    // 提前计算 Pair 的合约地址；由于利用的 create2 创建币对，所以币对的地址是可以提前预测的
    function predictedAddr(address tokenA, address tokenB) public view returns(address){
        require(tokenA != tokenB, unicode"tokenA 和 tokenB 不能相同");
        // 用两个进行升序排序的 token 计算 salt
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        // 计算的 salt 为 tokenA 和 tokenB 的 hash
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        // 计算地址
        // [0x2c44b726ADF1963cA47Af88B284C06f30380fC78, 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c] => 0xB241860Ad4C02d6abc80F54dbF472c9B440d7a8e
        address predictedAddress = address(
            uint160(
                uint(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff), // 一个常数 这里是 16 进制，也就是 10 进制的 255
                            address(this), // 当前合约地址
                            salt, // 盐
                            // initCode
                            keccak256(type(Pair).creationCode)
                            // keccak256(
                            //     abi.encodePacked(
                            //         type(Pair).creationCode,
                            //         abi.encode(address(this))
                            //     )
                            // )
                        )
                    )
                )
            )
        );

        return predictedAddress;
    }
}