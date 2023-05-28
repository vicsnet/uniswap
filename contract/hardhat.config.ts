import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from "dotenv"
dotenv.config();


const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks:{
    sepolia:{
      url:process.env.SEPOLIA_URL,
      // @ts-ignore
      accounts:[process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    // @ts-ignore
    apiKey: process.env.API_KEY
  }
};

export default config;
