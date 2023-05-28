import { ethers } from "hardhat";

async function main(){


    // whiteList 
    const whitelistContract = await ethers.getContractFactory("Whitelist");

    const deployedWhitelistContract = await whitelistContract.deploy(10);

    await deployedWhitelistContract.deployed();

    console.log("Whitelist Contract Address:", deployedWhitelistContract.address);


    
    // NFT collection CryptoDevs
const metadataURL="https://nft-collection-sneh1999.vercel.app/api/";

const cryptoDevsContract = await ethers.getContractFactory("CryptoDevs")

const deployedCryptoDevsContract = await cryptoDevsContract.deploy(metadataURL, deployedWhitelistContract.address)

await deployedCryptoDevsContract.deployed();

// print the address of the deployed contract
console.log(
  "Crypto Devs Contract NFT Address:",
  deployedCryptoDevsContract.address
);

// launch ICO



const cryptoDevsTokenContract = await ethers.getContractFactory(
  "CryptoDevToken"
);

// deploy the contract
const deployedCryptoDevsTokenContract = await cryptoDevsTokenContract.deploy(
    deployedCryptoDevsContract.address
);

await deployedCryptoDevsTokenContract.deployed();
// print the address of the deployed contract
console.log(
  "Crypto Devs Token Contract Address:",
  deployedCryptoDevsTokenContract.address
);

// Exchange

  const exchangeContract = await ethers.getContractFactory("Exchange");

  // here we deploy the contract
  const deployedExchangeContract = await exchangeContract.deploy(
    deployedCryptoDevsTokenContract.address
  );
  await deployedExchangeContract.deployed();

  // print the address of the deployed contract
  console.log("Exchange Contract Address:", deployedExchangeContract.address);

}

main().then(()=>process.exit(0)). catch((error)=>{
    console.error(error);
    process.exit(1)
})