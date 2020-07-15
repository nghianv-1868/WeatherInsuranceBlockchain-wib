const HDWalletProvider = require('truffle-hdwallet-provider')

// Thư viện để sử dụng được biến môi trường
require('dotenv').config()

module.exports = {
  // Phần này là cấu hình thư mục để xuất các file sau khi complier
  contracts_build_directory: '../frontend/src/contracts',

  // Đây là các thiết lập cho các môi trường mình sẽ deploy lên
  // Vd:
  //   + Môi trường phát triển(Development) thì sẽ trỏ đến host nào, port bao nhiêu
  //   + Môi trường Live - tức môi trường thật
  networks: {
    development: {
      host: '127.0.0.1',
      port: '8545',
      network_id: '*', // Match any network id
    },
    cldev: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    live: {
      provider: () => {
        // Phần này sẽ là các thông số như MNEMONIC - là private key để deploy,
        // RPC_URL - chính là node Ethereum mình sẽ deploy lên
        return new HDWalletProvider(process.env.MNEMONIC, process.env.RPC_URL)
      },
      network_id: '*',
      skipDryRun: true,
    },
  },

  // Cấu hình phiên bản sẽ sử dụng để compiler
  compilers: {
    solc: {
      version: '0.5.11',
      settings: {
        optimizer: {
          enabled: true,
          runs: 2,
        },
      },
    },
  },
}
