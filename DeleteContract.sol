// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Delete1 {
    constructor() payable {

    }
    
    function selfDestruct() external {
        selfdestruct(payable(msg.sender));
    }
    
    function getBalance() external view returns(uint balance) {
        balance = address(this).balance;
    }
}

contract Deploy {
    constructor() payable {
        
    }

    struct DemoResult {
        address addr;
        uint balance;
        // uint value;
    }
    
    function demo() external payable returns(DemoResult memory) {
        Delete1 del = new Delete1{value: msg.value}(); // 调用者调用 demo 时发所的 ETH 传入到 Delete1 合约中

        DemoResult memory res = DemoResult({
            addr: address(del),
            balance: del.getBalance()
        });

        del.selfDestruct();
        
        return res;   
    }
    
    function getBalance() external view returns(uint balance) {
        balance = address(this).balance;
    }
}