/* eslint-disable no-console */
import Web3 from 'web3';

const getWeb3 = async () => {
  // Đợi đến khi trang được load xong thì thực hiện tránh xảy ra lỗi với web3
  if (window.ethereum) {
    const web3 = new Web3(window.ethereum);
    try {
      // Yêu cầu truy cập tài khoản nếu cần
      await window.ethereum.enable();
      // Trả lại thông tin về tài khoản hiện tại sau khi xác thực ví
      return web3;
    } catch (error) {
      console.error(error);
    }
  }
  // Đối với các dapp browsers phiên bản cũ...
  else if (window.web3) {
    // sử dụng Mist/MetaMask's provider.
    const web3 = window.web3;
    console.log('Injected web3 detected.', window.web3);
    return web3;
  }
  // Nếu không thấy provider thì sẽ mặc định sử dụng mạng local...
  else {
    const provider = new Web3.providers.HttpProvider('http://127.0.0.1:9545');
    const web3 = new Web3(provider);
    console.log('No web3 instance injected, using Local web3.');
    return web3;
  }
};

export default getWeb3;
