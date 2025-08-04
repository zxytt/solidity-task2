// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error NotOwner();

contract MyERC20 {
  // 代币名称
  string public name;
  // 代币符号
  string public symbol;
  // 代币精度
  uint8 public decimals;
  // 总供应量
  uint256 public totalSupply;
  // 代币拥有者
  address public owner;

  // 账户余额
  mapping(address => uint256) public _balances;
  // 授权
  mapping(address => mapping(address => uint256)) public _allowances;
  // 事件
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    uint256 _totalSupply
  ) {
    owner = msg.sender;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;

    // 初始供应量分配给合约所有者
    _mint(owner, _totalSupply * 10 ** uint256(_decimals));
  }

  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert NotOwner();
    }
    _;
  }

  function balanceOf(address account) public view returns (uint256) {
    return _balances[account];
  }

  function transfer(address recipient, uint256 amount) public returns (bool) {
      require(recipient != address(0), "SimpleERC20: transfer to the zero address");
      require(_balances[msg.sender] >= amount, "SimpleERC20: insufficient balance");
      
      _balances[msg.sender] -= amount;
      _balances[recipient] += amount;
      
      emit Transfer(msg.sender, recipient, amount);
      return true;
  }

  // 允许合约所有者增发代币
  function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
  }

  function _mint(address to, uint256 amount) internal {
    totalSupply += amount;
    _balances[to] += amount;
    emit Transfer(address(0), to, amount);
  }
}