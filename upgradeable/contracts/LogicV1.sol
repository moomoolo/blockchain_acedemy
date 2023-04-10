// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract LogicV1 {
  uint256 private total;

  // logic 
  function getTotal() public view returns(uint256) {
    return total;
  }

  function increment() public {
    total = total + 1;
  }

}