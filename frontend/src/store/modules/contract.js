/* eslint-disable no-console */
import getWeb3 from '@/utils/getWeb3';
import Factory from '@/contracts/WibFactory.json';
import Wib from '@/contracts/Wib.json';
const state = {
  web3: null,
  account: null,
  balance: 0,
  factory: null,
  wibs: [],
  insurances: [],
  customers: [],
  manager: null,
  wibsByAdmin: [],
};

const mutations = {
  setWeb3(state, payload) {
    state.web3 = payload.web3;
    state.balance = payload.balance;
    state.account = payload.account;
  },
  setFactory(state, payload) {
    state.factory = payload.factoryFunc;
  },
  setMyWibs(state, payload) {
    state.wibs = payload.wibs;
  },
  setInsurances(state, payload) {
    state.insurances = payload.insurances;
  },
  setCustomers(state, payload) {
    state.customers = payload.customers;
  },
  setManager(state, payload) {
    state.manager = payload.manager;
  },
  setAdminWibs(state, payload) {
    state.setAdminWibs = payload.setAdminWibs;
  },
};

const actions = {
  async setWeb3({ commit }) {
    const web3 = await getWeb3();
    const accounts = await web3.eth.getAccounts();
    window.web3.version.getNetwork((e, netId) => {
      if (netId !== '3') {
        alert(
          'Unknown network, please change network to Ropsten testnet network'
        );
        return;
      }
    });
    if (accounts.length > 0) {
      const account = accounts[0];
      let balance = await web3.eth.getBalance(account);
      balance = parseFloat(web3.utils.fromWei(balance)).toFixed(2);
      commit('setWeb3', { web3: getWeb3, balance, account });
    } else {
      console.log('Account not found');
    }
  },

  async initContarct({ commit, state }) {
    const web3 = await state.web3();
    const networkId = process.env.VUE_APP_NETWORK_ID;
    const factory = new web3.eth.Contract(
      Factory.abi,
      Factory.networks[networkId].address,
      {
        transactionConfirmationBlocks: 1,
      }
    );
    let manager = await factory.methods.manager().call();
    let factoryFunc = () => factory;
    commit('setFactory', { factoryFunc });
    commit('setManager', { manager });
  },

  async getAllWib({ commit, state }) {
    const factory = await state.factory();
    const account = await state.account;
    const web3 = await state.web3();
    let wibAddresses = await factory.methods
      .getAllContract(account)
      .call({ from: account });
    let wibs = [];
    for (let i = 0; i < wibAddresses.length; i++) {
      let wib = {
        instance: null,
        address: null,
      };

      wib.instance = new web3.eth.Contract(Wib.abi, wibAddresses[i], {
        transactionConfirmationBlocks: 1,
      });
      wib.address = wibAddresses[i];
      wibs.push(wib);
    }
    commit('setMyWibs', { wibs });
  },

  async createWib({ state }, param) {
    const factory = await state.factory();
    const account = await state.account;

    let coordinate;
    let gmtOffset;

    await fetch(
      `https://us1.locationiq.com/v1/search.php?key=${process.env.VUE_APP_KEY_GET_COORDINATE}&q=${param.location}&format=json`
    )
      .then((response) => response.json())
      .then((data) => {
        coordinate = data ? data[0] : '';
      });

    await fetch(
      `http://api.timezonedb.com/v2.1/get-time-zone?key=${process.env.VUE_APP_KEY_GET_TIMEZONE}&format=json&by=position&lat=${coordinate.lat}&lng=${coordinate.lon}`
    )
      .then((response) => response.json())
      .then((data) => (gmtOffset = data.gmtOffset));

    var tempTimes = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
      '20',
      '21',
      '22',
      '23',
    ];
    var timesbyte = param.times.split('');
    var timesArray = [];
    var hour = 0;
    for (let i = 0; i < 24; i++) {
      if (timesbyte[i] === '1') {
        timesArray.push(tempTimes[i]);
        hour = i;
      }
    }

    hour++;

    let arrStr = param.date.split('-');
    var year = parseInt(arrStr[0]);
    var month = parseInt(arrStr[1]);
    var day = parseInt(arrStr[2]);
    console.log(
      [param.location, `${coordinate.lat},${coordinate.lon}`],
      gmtOffset,
      param.date,
      [year, month, day, hour],
      timesArray,
      param.priceWei,
      param.packageName,
      param.link,
      param.compensation
    );

    await factory.methods
      .createWib(
        [param.location, `${coordinate.lat},${coordinate.lon}`],
        gmtOffset,
        param.date,
        [year, month, day, hour],
        timesArray,
        param.priceWei,
        param.packageName,
        param.link,
        param.compensation
      )
      .send({ from: account, value: param.priceWei })
      .then(() => {
        console.log('create success');
      })
      .catch((e) => {
        throw e;
      });
  },

  async getAllInsurancePackage({ commit, state }) {
    const factory = await state.factory();
    const account = await state.account;
    let insurances = await factory.methods
      .getAllInsurancePackage()
      .call({ from: account });
    commit('setInsurances', { insurances });
  },
  async getAllCustomers({ commit, state }) {
    const factory = await state.factory();
    const account = await state.account;
    let customers = await factory.methods
      .getAllCustomer()
      .call({ from: account });
    commit('setCustomers', { customers });
  },
  async addInsurancePackage({ state }, param) {
    const factory = await state.factory();
    const account = await state.account;

    await factory.methods
      .addInsurancePackage(param.name, param.priceUSD, param.rate)
      .send({ from: account })
      .then(() => {
        console.log('create insurance package success');
      })
      .catch((e) => {
        console.log('Create insurance package error', e);
      });
  },
  async getAllWibsByAdmin({ commit, state }) {
    const factory = await state.factory();
    const account = await state.account;
    const web3 = await state.web3();
    let wibAddresses = await factory.methods
      .getAllCustomer()
      .call({ from: account });
    let wibsByAdmin = [];
    for (let i = 0; i < wibAddresses.length; i++) {
      let wib = {
        instance: null,
        address: null,
      };

      wib.instance = new web3.eth.Contract(Wib.abi, wibAddresses[i], {
        transactionConfirmationBlocks: 1,
      });
      // let paid = await wib.instance.methods.price().call({ from: account });

      // console.log('paid', paid);
      // if (paid == false) {
      //   wib.address = wibAddresses[i];
      //   wibsByAdmin.push(wib);
      // }
    }
    commit('setAdminWibs', { wibsByAdmin });
  },
};

const getters = {};

export const contract = {
  namespaced: true,
  state,
  getters,
  mutations,
  actions,
};
