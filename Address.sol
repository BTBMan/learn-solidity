// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Address 库
library Address {
  // 利用 extcodesize 判断一个地址是否为合约地址
  function isContract(address account) internal view returns (bool) {
    uint size;
    assembly {
      size := extcodesize(account)
    }
    return size > 0;
  }
}
