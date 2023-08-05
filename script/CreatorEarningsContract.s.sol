// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CreatorEarningsContract {
    address public owner;
    uint256 public contractBalance;
    uint256 public creatorSharePercentage = 10; // 10% goes to the creator

    event Deposit(address indexed sender, uint256 amount);
    event Withdraw(address indexed receiver, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function deposit() external payable {
        contractBalance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        require(contractBalance > 0, "Contract balance is empty.");
        uint256 creatorEarnings = (contractBalance * creatorSharePercentage) / 100;
        uint256 ownerEarnings = contractBalance - creatorEarnings;
        
        // Reset contract balance before transferring to avoid reentrancy attacks
        contractBalance = 0;

        // Transfer the earnings
        payable(owner).transfer(ownerEarnings);
        payable(msg.sender).transfer(creatorEarnings);

        emit Withdraw(owner, ownerEarnings);
        emit Withdraw(msg.sender, creatorEarnings);
    }
}
