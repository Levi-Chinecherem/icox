const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  try {
    const ICOXContract = await hre.ethers.getContractFactory("ICOXContract");
    const icoXContract = await ICOXContract.deploy();

    console.log("Contract deployment transaction sent. Awaiting confirmation...");

    // Retrieve and log the address from `target`
    console.log("ICOXContract deployed to:", icoXContract.target);
  } catch (error) {
    console.error("Error deploying ICOXContract:", error.message || error);
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error.message || error);
    process.exit(1);
  });


This worked! Here's a breakdown of what I did differently in this version of the script, which made the deployment message display correctly:

### 1. **Using `icoXContract.target` Instead of `icoXContract.address`**

   - In Hardhat's `BaseContract` object, the deployed contract's address wasn't available under `icoXContract.address` as expected; instead, it was stored in the `target` property.
   - This property (`icoXContract.target`) represents the address where the contract is actually deployed on the network. By directly using `icoXContract.target`, we avoid the issue of the `address` property being `undefined`.

### 2. **Avoided Calling Non-Existent Functions**

   - Earlier attempts used `icoXContract.deployed()` or `icoXContract.deployTransaction.wait()`, which led to errors since these methods weren't available or compatible with the contract object after deployment.
   - In this successful script, I removed those calls and directly accessed `icoXContract.target` to get the address, simplifying the script and reducing potential errors.

### Summary of the Fix

In brief, we:
- **Directly accessed `icoXContract.target`** to get the deployed address, rather than relying on `icoXContract.address`.
- **Avoided unnecessary deployment-related calls** that weren't functioning as expected in the Hardhat environment.

This way, your deployment process is straightforward, and the deployed address prints correctly without needing additional transaction waits or address lookups.