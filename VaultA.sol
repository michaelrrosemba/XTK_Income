// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract VaultA {
    IERC20 public immutable xtkToken;

    mapping(address => uint256) private _balances;

    constructor() {
        // ✅ CORRECT FINAL XTK2 TOKEN ADDRESS
        xtkToken = IERC20(0x0FCa5E3ca52f7926C2adC2D0E1A4416B348adE6c);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Cannot deposit 0");

        bool success = xtkToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed");

        _balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        _balances[msg.sender] -= amount;

        bool success = xtkToken.transfer(msg.sender, amount);
        require(success, "Token transfer failed");
    }

    function xtkBalanceOf(address user) external view returns (uint256) {
        return _balances[user];
    }
}
