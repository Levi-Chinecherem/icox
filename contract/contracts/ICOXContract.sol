// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAutomatedWallet {
    function transferToContract(address contractAddress, uint256 amount) external;
}

contract ICOXContract {
    address public owner;
    mapping(address => bool) public authorizedWallets;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);
    event Authorization(address indexed userWallet, address automatedWallet);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized: Owner only");
        _;
    }

    modifier onlyAuthorized() {
        require(authorizedWallets[msg.sender] == true, "Not authorized");
        _;
    }

    // Function to authorize an automated wallet to deposit on behalf of a user
    function authorizeAutomatedWallet(address automatedWallet) external {
        authorizedWallets[automatedWallet] = true;
        emit Authorization(msg.sender, automatedWallet);
    }

    // Accept deposits from the user's automated wallet
    function deposit() public payable onlyAuthorized {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        emit Deposit(msg.sender, msg.value);
    }

    // Allow the owner to withdraw from the contract
    function withdraw(uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(owner).transfer(amount);
        emit Withdrawal(owner, amount);
    }

    // Function to check contract balance, accessible only by the owner
    function checkBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // Fallback function to accept Ether
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
