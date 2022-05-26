const HDWalletProvider = require('@truffle/hdwallet-provider');
const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_directory: './contracts/',
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.1",    // Fetch exact version from solc-bin (default: truffle's version)
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  },

  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    selise: {
      provider: () => new HDWalletProvider(`d043b90f5073f4f3768a86a51fee6ddd1a1df7b395712421b2c66da0834b574a`, `http://testnet-cta-2096138246.eu-central-1.elb.amazonaws.com`),
      network_id: 181,
      confirmations: 1,
      networkCheckTimeout: 1000000,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bsc: {
      provider: () => new HDWalletProvider(`d043b90f5073f4f3768a86a51fee6ddd1a1df7b395712421b2c66da0834b574a`, `https://data-seed-prebsc-2-s3.binance.org:8545/`),
      network_id: 97,
      confirmations: 1,
      networkCheckTimeout: 1000000,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    rinkeby: {
      provider: () => new HDWalletProvider(`d043b90f5073f4f3768a86a51fee6ddd1a1df7b395712421b2c66da0834b574a`, `https://rinkeby.infura.io/v3/989463cceccb4c17b44b5b5a6068cf2a`),
      network_id: 4,
      confirmations: 1,
      networkCheckTimeout: 1000000,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    matic: {
      provider: () => new HDWalletProvider(`d043b90f5073f4f3768a86a51fee6ddd1a1df7b395712421b2c66da0834b574a`, `https://rpc-mumbai.maticvigil.com/v1/972750472dea9a17a28b1d867ac86c61e8b29569`),
      network_id: 80001,
      confirmations: 1,
      networkCheckTimeout: 1000000,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    fantom: {
      provider: () => new HDWalletProvider(`d043b90f5073f4f3768a86a51fee6ddd1a1df7b395712421b2c66da0834b574a`, `https://rpc.testnet.fantom.network`),
      network_id: 4002,
      confirmations: 1,
      networkCheckTimeout: 1000000,
      timeoutBlocks: 200,
      skipDryRun: true
    }   
  }
};
