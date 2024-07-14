// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./PriceConverter.sol";

contract FundMe {
  using PriceConverter for uint256;

  address public owner;

  uint256 public minimumUsd = 5e18;

  address[] public funders;
  mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

  constructor() {
    owner = msg.sender; // save deployer
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Sender is not owner!");
    _;
  }

  function fund() public payable {
    require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough!");

    funders.push(msg.sender);
    addressToAmountFunded[msg.sender] += msg.value;
  }

  function withdraw() public onlyOwner {
    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
      address funder = funders[funderIndex];
      addressToAmountFunded[funder] = 0;
    }

    funders = new address[](0); // reset funders to brand new blank address array
    (bool callSuccess, ) = payable(msg.sender).call{
      value: address(this).balance
    }("");

    require(callSuccess, "Call failed!");
  }
}
