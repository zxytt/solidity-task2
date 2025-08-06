// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error NotOwner();

contract MyBeg {
  // 定义一个变量，用于存储合约的创建者
  address public owner;

  // 记录所有用户地址
  address[] public allUsers;

  // 定义一个映射，用于存储用户的捐赠金额
  mapping(address => uint256) public users;

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert NotOwner();
    }
    _;
  }

  // 定义一个函数，用于接收用户的捐赠
  function donate() public payable {
    // 检查用户是否已经存在，如果不存在，则创建一个新的用户
    if (users[msg.sender] == 0) {
      allUsers.push(msg.sender);
    }
    users[msg.sender] += msg.value;
  }

  // 定义一个函数，用于查询用户的捐赠金额
  function getDonationAmount(address user) public view returns (uint256) {
    return users[user];
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

  // 获取前三名捐赠者
  function getTopDonators() public view returns (address[] memory) {
    address[] memory topAddresses = new address[](3);
    uint256[] memory topAmounts = new uint256[](3);

    for (uint256 i = 0; i < allUsers.length; i++) {
      address donor = allUsers[i];
      uint256 amount = users[donor];
      for (uint256 j = 0; j < 3; j++) {
          if (amount > topAmounts[j]) {
              // 排名后移
              for (uint256 k = 2; k > j; k--) {
                  topAmounts[k] = topAmounts[k - 1];
                  topAddresses[k] = topAddresses[k - 1];
              }
              // 插入当前捐赠者
              topAmounts[j] = amount;
              topAddresses[j] = donor;
              break;
          }
      }
    }
    return topAddresses;
  }

  // 直接转账也记录到捐赠记录中
  receive() external payable {
    if(msg.value > 0) {
      donate();
    }
  }
}