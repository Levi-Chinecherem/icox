// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IICOXContract {
    function deposit() external payable;
}

contract AutomatedWallet {
    address public owner;
    address public icoxContract;

    event DepositInitiated(uint256 amount, address to);
    event AuthorizedContract(address icoxContract);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    // Function to set the ICOX contract address and authorize it
    function authorizeICOXContract(address _icoxContract) external onlyOwner {
        icoxContract = _icoxContract;
        emit AuthorizedContract(_icoxContract);
    }

    // Fund the wallet to ensure it has enough balance for deposits
    receive() external payable {}

    // Function to automatically transfer funds to the ICOXContract
    function automatedDeposit(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance in AutomatedWallet");
        require(icoxContract != address(0), "ICOX contract not authorized");

        IICOXContract(icoxContract).deposit{value: amount}();
        emit DepositInitiated(amount, icoxContract);
    }

    // Function to withdraw all Ether back to the owner (in case of need)
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
