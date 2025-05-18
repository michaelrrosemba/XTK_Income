// SPDX-License-Identifier: MIT pragma solidity ^0.8.20;

interface IWMATIC { function deposit() external payable; function transfer(address to, uint256 amount) external returns (bool); }

interface IPOL { function transfer(address to, uint256 amount) external returns (bool); }

contract VaultA { address public owner; address public wmatic; address public pol;

constructor(address _wmatic, address _pol) {
    owner = msg.sender;
    wmatic = _wmatic;
    pol = _pol;
}

receive() external payable {}

modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

function deposit() external payable {
    require(msg.value > 0, "No MATIC sent");
}

function swapToPOL(uint256 amount) external onlyOwner {
    require(address(this).balance >= amount, "Not enough MATIC");
    IWMATIC(wmatic).deposit{value: amount}();
    IWMATIC(wmatic).transfer(pol, amount);
}

function withdraw(uint256 amount) external onlyOwner {
    require(address(this).balance >= amount, "Not enough balance");
    payable(owner).transfer(amount);
}

}

