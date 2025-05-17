// SPDX-License-Identifier: MIT pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; import "@openzeppelin/contracts/access/Ownable.sol";

contract VaultA is Ownable { address public tokenAddress; // POL token

event Deposited(address indexed user, uint256 amount);
event Withdrawn(address indexed user, uint256 amount);
event Swapped(address indexed user, uint256 amount);

constructor(address _tokenAddress) Ownable(msg.sender) {
    tokenAddress = _tokenAddress;
}

// Allow contract to receive MATIC
receive() external payable {
    emit Deposited(msg.sender, msg.value);
}

// Deposit MATIC into the contract
function deposit() external payable {
    require(msg.value > 0, "Must send MATIC");
    emit Deposited(msg.sender, msg.value);
}

// Withdraw MATIC from the contract by owner
function withdraw(uint256 amount) external onlyOwner {
    require(address(this).balance >= amount, "Insufficient balance");
    (bool success, ) = payable(msg.sender).call{value: amount}("");
    require(success, "Withdraw failed");
    emit Withdrawn(msg.sender, amount);
}

// Swap MATIC for POL (mock: owner-triggered transfer)
function swapToPOL(uint256 amount) external onlyOwner {
    require(address(this).balance >= amount, "Insufficient MATIC");

    IERC20 token = IERC20(tokenAddress);
    require(token.balanceOf(address(this)) >= amount, "Insufficient POL tokens");

    // Transfer POL to owner for demo
    require(token.transfer(msg.sender, amount), "Token transfer failed");
    emit Swapped(msg.sender, amount);
}

// View contract MATIC balance
function getBalance() external view returns (uint256) {
    return address(this).balance;
}

}

