import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    localhost: {
      url: "http://localhost:8545"
    },
    bsctest: {
      url: "https://bsc-testnet.public.blastapi.io",
      accounts: [process.env.PRIVATE_KEY || ''],
    }
  }
};

export default config;
