pragma solidity >=0.5.0 <0.6.0;
pragma experimental ABIEncoderV2;

import "./Wib.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/evm-contracts/src/v0.5/ChainlinkClient.sol";


contract WibFactory is ChainlinkClient{
    
  uint constant SECONDS_PER_DAY = 24 * 60 * 60;
  uint constant SECONDS_PER_HOUR = 60 * 60;
  int constant OFFSET19700101 = 2440588;

  struct AllInsuranceOfBuyer{
    address[] allInsurance;
    uint8  exist;
  }

  struct InsurancePackage{
    string name;
    uint256 priceUSD;
    uint256 rate;
  }

  address payable public manager;

  mapping (address => AllInsuranceOfBuyer) public contractsOfBuyer;
  mapping (string => InsurancePackage) insurancePackage;

  address[] public allCustomers;
  InsurancePackage[] allPackage;
  uint256 public linkAmount = 10;
  uint256 public amountTokenLink;

  constructor() public {
    manager = msg.sender;

    InsurancePackage memory pack1;
    pack1.name = "Silver";
    pack1.priceUSD = 10;
    pack1.rate = 25;
    insurancePackage["Silver"] = pack1;
    allPackage.push(pack1);

    InsurancePackage memory pack2;
    pack2.name = "Gold";
    pack2.priceUSD = 50;
    pack2.rate = 60;
    insurancePackage["Gold"] = pack2;
    allPackage.push(pack2);

    InsurancePackage memory pack3;
    pack3.name = "Platinum";
    pack3.priceUSD = 100;
    pack3.rate = 100;
    insurancePackage["Platinum"] = pack3;
    allPackage.push(pack3);
    
    setPublicChainlinkToken();
    
  }

  event contractDeployed(
    address Wib
  );

  event AddPackage(
    bool success
  );

  modifier onlyManager(){
	require(msg.sender == manager, "Unauthorised , must be manager");
	_;
  }
  
  function getAllCustomer() public view onlyManager returns(address[] memory) {
    return allCustomers;
  }

  function getInsurancePackage(string memory _name) public view returns(InsurancePackage memory) {
    return (insurancePackage[_name]);
  }

  function addInsurancePackage(string memory _name, uint256 _priceUSD, uint256 rate) public onlyManager {
    InsurancePackage memory package;
    package.name = _name;
    package.priceUSD = _priceUSD;
    package.rate = rate;
    insurancePackage[_name] = package;
    allPackage.push(package);
    
    emit AddPackage(true);
  }

  function setLINKAmount(uint256 _linkAmount) public onlyManager {
    linkAmount = _linkAmount;
  }
  
  function withDrawAllEther() public payable onlyManager {
	manager.transfer(address(this).balance);
  }

  function createWib(
    string[] memory _location,
    uint256 _gmtOffset,
    string memory _date,
    uint256[] memory _dateInt,
    string[] memory _timesArray,
    // string memory _timeString,
    uint256 _priceWei,
    string memory _packageName,
    address _link,
    uint256 _compensation
  ) public payable {
    require(msg.value >= _priceWei, "Not Enough Money");

    uint256 rate = insurancePackage[_packageName].rate;
    
    uint256  _expired = timestampFromDateTime(_dateInt[0], _dateInt[1], _dateInt[2], _dateInt[3]);

    address payable packageInsurance = address(new Wib(msg.sender, _location , _gmtOffset  , _date , _expired , _timesArray , _priceWei, rate, linkAmount ,_link, manager));
    

    packageInsurance.transfer(_compensation);

    LinkTokenInterface link = LinkTokenInterface(0x20fE562d797A42Dcb3399062AE9546cd06f63280);
    link.transfer(packageInsurance, linkAmount * LINK);

    if(contractsOfBuyer[msg.sender].exist != 1){
      contractsOfBuyer[msg.sender].allInsurance.push(packageInsurance);
      contractsOfBuyer[msg.sender].exist = 1;
      allCustomers.push(msg.sender);
    } else {
      contractsOfBuyer[msg.sender].allInsurance.push(packageInsurance);
    }

    emit contractDeployed(packageInsurance);
  }
  
  
  function getAllContract(address _buyer) public view returns(address[] memory) {
    // require(msg.sender == _buyer || msg.sender == manager, "Permission Denided !");
    return contractsOfBuyer[_buyer].allInsurance;
  }

  function getAllInsurancePackage() public view returns(InsurancePackage[] memory){
    return allPackage;
  }
   
  function getChainlinkToken() public view returns (uint256) {
    return LinkTokenInterface(chainlinkTokenAddress()).balanceOf(address(this)); 
  }
  
  function getBalance() public view returns (uint256){
	return address(this).balance;
  }
  
  function _daysFromDate(uint _year, uint _month, uint _day) internal pure returns (uint _days) {
    require(_year >= 1970);
    int _year_ = int(_year);
    int _month_ = int(_month);
    int _day_ = int(_day);

    int __days = _day_
      - 32075
      + 1461 * (_year_ + 4800 + (_month_ - 14) / 12) / 4
      + 367 * (_month_ - 2 - (_month_ - 14) / 12 * 12) / 12
      - 3 * ((_year_ + 4900 + (_month_ - 14) / 12) / 100) / 4
      - OFFSET19700101;

    _days = uint(__days);
  }
  
  function timestampFromDateTime(uint _year, uint _month, uint _day, uint _hour) public pure returns (uint _timestamp) {
    _timestamp = _daysFromDate(_year, _month, _day) * SECONDS_PER_DAY + _hour * SECONDS_PER_HOUR;
  }
  
  function() external payable {}
}