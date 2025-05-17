// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

contract VaultA {
    address public owner;

    IERC20 public constant XTK2 = IERC20(0xB84F20171e80B581089E1c2B5EF7325bB96Fba61); // XTK2
    IERC20 public constant WMATIC = IERC20(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270); // WMATIC
    IUniswapV2Router public constant router = IUniswapV2Router(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff); // QuickSwap

    event TokensSwapped(uint256 inputAmount, uint256 outputAmount);
    event Withdraw(address token, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function swapToWMATIC(uint256 amountIn, uint256 amountOutMin) external onlyOwner {
        require(XTK2.balanceOf(address(this)) >= amountIn, "Insufficient XTK2");

        XTK2.approve(address(router), amountIn);

        address ;
        path[0] = address(XTK2);
        path[1] = address(WMATIC);

        uint256[] memory result = router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            address(this),
            block.timestamp + 300
        );

        emit TokensSwapped(amountIn, result[1]);
    }

    function withdrawWMATIC(uint256 amount) external onlyOwner {
        require(WMATIC.transfer(msg.sender, amount), "WMATIC transfer failed");
        emit Withdraw(address(WMATIC), amount);
    }

    function withdrawXTK(uint256 amount) external onlyOwner {
        require(XTK2.transfer(msg.sender, amount), "XTK2 transfer failed");
        emit Withdraw(address(XTK2), amount);
    }

    function getXTKBalance() external view returns (uint256) {
        return XTK2.balanceOf(address(this));
    }

    function getWMATICBalance() external view returns (uint256) {
        return WMATIC.balanceOf(address(this));
    }
}