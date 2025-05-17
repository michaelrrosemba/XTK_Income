// SPDX-License-Identifier: MIT pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol"; import "@openzeppelin/contracts/access/Ownable.sol";

interface IPOL { function deposit(uint256 amount) external; }

contract VaultA is Ownable { using SafeERC20 for IERC20;

address public constant POL_TOKEN = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619; // POL (ERC20 Wrapper)
address public constant WMATIC_TOKEN = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270; // Wrapped MATIC
address public constant RECEIVER = 0x7a523a378e047C4c4744c1BA128BB0B8D9915b83; // AUTO-XTK-001

event Deposited(address indexed user, uint256 amount);
event SwappedToPOL(address indexed user, uint256 amount);
event Withdrawn(address indexed to, uint256 amount);

receive() external payable {}

function deposit() external payable {
    require(msg.value > 0, "No MATIC sent");
    emit Deposited(msg.sender, msg.value);
}

function swapToPOL(uint256 amount) external onlyOwner {
    require(amount > 0, "Amount must be > 0");

    IWETH(WMATIC_TOKEN).deposit{value: amount}();
    IERC20(WMATIC_TOKEN).safeApprove(POL_TOKEN, amount);

    IPOL(POL_TOKEN).deposit(amount);
    IERC20(POL_TOKEN).safeTransfer(RECEIVER, amount);

    emit SwappedToPOL(msg.sender, amount);
}

function withdraw(uint256 amount) external onlyOwner {
    require(amount > 0, "Amount must be > 0");
    payable(RECEIVER).transfer(amount);
    emit Withdrawn(RECEIVER, amount);
}

}

interface IWETH { function deposit() external payable; }

