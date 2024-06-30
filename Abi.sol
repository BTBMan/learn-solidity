// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Abi {
    uint x = 10;
    address addr = 0x7A58c0Be72BE218B41C608b7Fe7C5bB630736C71;
    string name = "0xAA";
    uint[2] array = [5, 6];

    bytes public encodeData;
    
    function encode() public returns(bytes memory result){
        // 会将每个参数填充为 32 字节的数据
        result = abi.encode(x, addr, name, array);
        encodeData = result;

        return result;
    }

    function encodePacked() public view returns(bytes memory result){
        // 会将每个参数以其最低空间编码
        result = abi.encodePacked(x, addr, name, array);
    }

    function encodeWithSignature() public view returns(bytes memory result){
        // 调用其他合约的时候使用，第一个参数为函数签名
        result = abi.encodeWithSignature("foo(uint256,address,string,uint256[2])", x, addr, name, array);
    }

    function encodeWithSelector() public view returns(bytes memory result){
        // 与 encodeWithSignature 类似，只不过第一个参数为函数选择器（函数签名 Keccak 哈希的前 4 个字节)
        result = abi.encodeWithSelector(bytes4(keccak256("foo(uint256,address,string,uint256[2])")), x, addr, name, array);
    }

    function decode() public view returns(uint dx, address daddr, string memory dstring, uint[2] memory duintArray){
        require(encodeData.length != 0, unicode"encodeData 不能为空");
        // 解 encode
        (dx, daddr, dstring, duintArray) = abi.decode(encodeData, (uint, address, string, uint[2]));
    }
}