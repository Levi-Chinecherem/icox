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
