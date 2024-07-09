// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC721.sol";

contract Test {
  function test() public pure returns (bytes4) {
    return type(IERC721).interfaceId;
  }
}
