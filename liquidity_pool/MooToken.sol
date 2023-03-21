// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract MooToken is IERC20 {
    string private _name = 'MooToken';
    string private _symbol = 'Moo';
    uint8 private _decimals = 18;
    uint256 private _totalSupply = 1_000_000 * 1e18;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() {
        _balances[address(0)] = _totalSupply;
        _transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        address owner = msg.sender;
        
        _transfer(owner, to, value);

        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        address spender = msg.sender;
        uint256 approvedValue = _allowances[from][spender];
        require(approvedValue >= value, "No enough approved");
        _approve(from, spender, approvedValue - value);
        _transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        uint256 fromBalance = _balances[from];
        
        require(fromBalance >= value, "No enough balance");

        _balances[from] -= value;
        _balances[to] += value;

        emit Transfer(from, to, value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
}