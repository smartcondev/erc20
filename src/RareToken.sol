//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./IERC20.sol";


contract RareToken is IERC20 {

    //State Variables
    string private _name;
    string private _symbol;
    uint8 private constant _decimals = 18;
    uint256 private _totalSupply;

    mapping(address => uint256) private balances;
    mapping(address =>mapping(address => uint256)) private allowances;

    constructor(string memory name_, string memory symbol_, uint256 initialSupply) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = initialSupply * 10 ** _decimals;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    //Reading function
    function name() external view returns(string memory) {
        return _name;
    }

    function symbol() external view returns(string memory) {
        return _symbol;
    }

    function decimals() external pure returns(uint8) {
        return _decimals;
    }

    function totalSupply() external view returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns(uint256) {
        return balances[account];
    }

    function allowance(address owner, address spender) external view returns(uint256) {
        return allowances[owner][spender];
    }

    // State Changing Function

    function transfer(address to, uint256 amount) external returns(bool) {

        require(to != address(0), "Receiver can not be address(0)");
        require(balances[msg.sender] >= amount, "Insufficient Balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns(bool) {
        require(spender != address(0), "Spender can not be address(0)");
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns(bool) {
        require(from != address(0), "Owner can not be address(0)");
        require(to != address(0), "Receiver can not be address(0)");
        require(balances[from] >= amount, "Insufficient Balance");
        require(allowances[from][msg.sender] >= amount, "Not enough allowance");
        balances[from] -= amount;
        allowances[from][msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;

    }

}