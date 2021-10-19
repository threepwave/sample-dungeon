/* This file goes in the root of your project */
require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("dotenv")


const ALCHEMY_API_KEY = process.env.alchemy_key;      // Your (test) Alchemy private key, pulled from your environment
const RINKEBY_PRIVATE_KEY = process.env.rinkeby_key;  // Your (test) wallet's private key
const ETHERSCAN_PRIVATE_KEY = process.env.etherscan_key;  // Your (test) Etherscan private key

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${RINKEBY_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_PRIVATE_KEY
  },
};

