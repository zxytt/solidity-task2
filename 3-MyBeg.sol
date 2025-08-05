// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error NotOwner();

contract MyBeg {
  // 定义一个结构体，用于存储每个用户的信息
  struct User {
    address addr;
    uint256 amount;
  }

  // 定义一个变量，用于存储合约的创建者
  address public owner;

  // 定义一个映射，用于存储用户信息
  mapping(address => User) public users;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender != address(this)) {
      revert NotOwner();
    }
    _;
  }

  // 定义一个函数，用于接收用户的捐赠
  function donate() public payable {
    // 检查用户是否已经存在，如果不存在，则创建一个新的用户
    if (users[msg.sender].amount == 0) {
      users[msg.sender] = User(msg.sender, msg.value);
    } else {
      // 如果用户已经存在，则将新的捐赠金额累加到用户的捐赠金额中
      users[msg.sender].amount += msg.value;
    }
  }

  // 定义一个函数，用于查询用户的捐赠金额
  function getDonationAmount(address user) public view returns (uint256) {
    return users[user].amount;
  }

  // 定义一个函数，用于查询合约的余额
  function getContractBalance() public view returns (uint256) {
    return address(this).balance;
  }

  // 定义一个函数，用于提取合约的余额
  function withdraw() public onlyOwner {
    // 检查合约的余额是否大于0
    require(address(this).balance > 0, "No balance to withdraw");
    // 将合约的余额发送给合约的创建者
    payable(msg.sender).transfer(address(this).balance);
  }

  // 直接转账也记录到捐赠记录中
  receive() external payable {
    if(msg.value > 0) {
      donate();
    }
  }
}