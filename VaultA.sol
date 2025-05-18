// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ERC20 Token Interface (Standard)
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// VaultA Contract — connected to XTK2 token
contract VaultA {
    // Token contract (hardcoded XTK2)
    IERC20 public xtkToken;

    // User balances inside the vault
    mapping(address => uint256) private _balances;

    // Constructor hardcodes token address
    constructor() {
        xtkToken = IERC20(0xc14ddb90C8fd16eEf4870aD779d04d52Cd5C6854);
    }

    // Deposit XTK2 tokens into vault
    function deposit(uint256 amount) external {
        require(amount > 0, "Cannot deposit 0");

        bool success = xtkToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");

        _balances[msg.sender] += amount;
    }

    // Withdraw XTK2 tokens from vault
    function withdraw(uint256 amount) external {
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        _balances[msg.sender] -= amount;

        bool success = xtkToken.transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }

    // View user vault balance
    function xtkBalanceOf(address user) external view returns (uint256) {
        return _balances[user];
    }
}
