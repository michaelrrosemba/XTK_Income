// SPDX-License-Identifier: MIT pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; import "@openzeppelin/contracts/access/Ownable.sol";

contract VaultA is Ownable { IERC20 public token; address public treasury;

constructor(IERC20 _token, address _treasury) {
    token = _token;
    treasury = _treasury;
}

receive() external payable {}

function deposit() external payable {
    require(msg.value > 0, "Send MATIC to deposit");
}

function swapToPOL() external onlyOwner {
    (bool sent, ) = treasury.call{value: address(this).balance}("");
    require(sent, "Failed to send MATIC");
}

function withdrawToken(address to, uint256 amount) external onlyOwner {
    require(token.transfer(to, amount), "Token transfer failed");
}

function updateTreasury(address newTreasury) external onlyOwner {
    require(newTreasury != address(0), "Invalid address");
    treasury = newTreasury;
}

function updateToken(IERC20 newToken) external onlyOwner {
    require(address(newToken) != address(0), "Invalid token");
    token = newToken;
}

function getBalance() external view returns (uint256 matic, uint256 tokenBal) {
    matic = address(this).balance;
    tokenBal = token.balanceOf(address(this));
}

}

