// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract External {
    constructor(uint n){
        require(n != 0, unicode"不能等于0");
        assert(n != 1);
    }

    function even(uint256 n) external pure returns(bool success){
        require(n % 2 == 0, unicode"n 不是偶数");
        success = true;
    }
}

contract TryCatch {
    event SuccessEvent();
    event CatchEvent(string msg);
    event CatchByte(bytes data);

    External ec;

    constructor(){
        ec = new External(2);
    }

    function try1(uint256 x) external {
        // 捕获外部合约调用成功或失败
        try ec.even(x) returns(bool _success) {
            // 成功时执行这个代码块里的内容
            emit SuccessEvent();
            _success = true;
        } catch Error(string memory reason){
            // 执行失败，并且有原因的时候，例如 require(false, msg)，有 msg 的情况下执行这个代码块里的内容
            emit CatchEvent(reason);
        }
    }

    function try2(uint256 x) external {
        // 用来捕获创建外部合约成功或失败
        try new External(x) returns(External _ec) {
            emit SuccessEvent();
            _ec = new External(x);
        } catch Error(string memory reason){
            emit CatchEvent(reason);
        } catch (bytes memory reason) {
            // 以上都不匹配的情况下，如 revert 或 require 没有第二参数
            emit CatchByte(reason);
        } 
    }
}