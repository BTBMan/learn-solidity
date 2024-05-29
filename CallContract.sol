// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// 被调合约
contract OtherContract {
    uint256 private x = 0;

    event Log(uint amount, uint gas);

    // 获取合约 ETH 余额
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function setX(uint256 _x) external payable {
        x = _x;

        // 如果有转入 ETH 则触发 Log 事件
        if (msg.value > 0) {
            emit Log(msg.value, gasleft());
        }
    }

    function getX() external view returns(uint){
        return x;
    }

}

// 调用合约
contract CallContract {
    function callSetXByAddr(address addr, uint256 x) external returns(uint) {
        // 通过已部署的合约地址 传递给以已部署的合约名称为名的函数 通过这个被创建的合约引用来调用其他合约 也可以调用合约内的函数
        // 这里使用和已部署的合约名称是为了编辑器不报错 并且可以知道合约内部的函数
        OtherContract(addr).setX(x);
        // 这个已部署的合约名可以是任何名字 在 remix 里试过都可以调用 只要地址传的是正确的
        // OtherContract3(addr).setX(x);

        // 可以把合约赋值给一个变量 再通过变量去调用合约
        OtherContract oc = OtherContract(addr);
        return oc.getX();
    }

    // 通过设置变量类型为其他合约的名字 其实底层还是 address，传递的参数也是 address 类型，通过这个变量调用合约内部的函数
    function callGetXByName(OtherContract addr) external view returns(uint) {
        // 通过合约名变量
        return addr.getX();
    }

    function callSetXWithTransfer(address addr, uint256 x) external payable {
        // 可以通过给带有 payable 的函数转账
        OtherContract(addr).setX{value: msg.value}(x);
    }
}