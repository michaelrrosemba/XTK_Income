// SPDX-License-Identifier: MIT pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; import "@openzeppelin/contracts/access/Ownable.sol";

interface IUniswapV2Router { function swapExactTokensForTokens( uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline ) external returns (uint256[] memory amounts); }

contract VaultA is Ownable { IERC20 public xtk = IERC20(0xc14ddb90C8fd16eEf4870aD779d04d52Cd5C6854); // XTokenV2 IERC20 public wmatic = IERC20(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270); // Wrapped MATIC IUniswapV2Router public router = IUniswapV2Router(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff); // QuickSwap router

event TokensSwapped(uint256 amountIn, uint256 amountOut);
event Withdraw(address indexed token, uint256 amount);

constructor() Ownable(msg.sender) {}

function swapXTKForWMATIC(uint256 amountIn, uint256 amountOutMin) external onlyOwner {
    require(xtk.balanceOf(address(this)) >= amountIn, "Insufficient XTK balance");

    xtk.approve(address(router), amountIn);

    address[] memory path = new address[](2);
    path[0] = address(xtk);
    path[1] = address(wmatic);

    uint256[] memory amounts = router.swapExactTokensForTokens(
        amountIn,
        amountOutMin,
        path,
        address(this),
        block.timestamp + 300
    );

    emit TokensSwapped(amountIn, amounts[1]);
}

function withdrawXTK(uint256 amount) external onlyOwner {
    require(xtk.transfer(msg.sender, amount), "XTK transfer failed");
    emit Withdraw(address(xtk), amount);
}

function withdrawWMATIC(uint256 amount) external onlyOwner {
    require(wmatic.transfer(msg.sender, amount), "WMATIC transfer failed");
    emit Withdraw(address(wmatic), amount);
}

function getXTKBalance() external view returns (uint256) {
    return xtk.balanceOf(address(this));
}

function getWMATICBalance() external view returns (uint256) {
    return wmatic.balanceOf(address(this));
}

}

