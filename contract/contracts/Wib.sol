pragma solidity >=0.5.0 <0.6.0;
pragma experimental ABIEncoderV2;

import "chainlink/v0.5/contracts/ChainlinkClient.sol";
import {
  SafeMath as SafeMath_Chainlink
} from "chainlink/v0.5/contracts/vendor/SafeMath.sol";

contract Wib is ChainlinkClient {
  
  using SafeMath_Chainlink for uint256;
  address private constant ORACLE_WEATHER = 0x4a3FBbB385b5eFEB4BC84a25AaADcD644Bd09721;
  bytes32 private constant JOB_ID_WEATHER = "58140c87248b4990809e3087f0774a0b";

  address private constant ORACLE_PRICE = 0xc99B3D447826532722E41bc36e644ba3479E4365;
  bytes32 private constant JOB_ID_PRICE = "3cff0a3524694ff8834bda9cf9c779a1";

  address payable manager;

  bool public paid = false;

  address payable buyer;
  string public nameLocation;
  string public location;
  string public date;
  string[] public times;
  uint256 public price;
  uint256 public rate;
  uint256 public linkAmount;
  uint256 public expired;
  uint256 public gmtOffset;
  uint256 public amountTokenLink;
  

  uint256 public totalRainyHours;
  uint256 public deploymentTime;
  uint256 public compensation;

  uint256[] public hourlyState;

  uint256 public etherPrice;
  int256 public firstHours;
  bool public isQueryWeather = false;

  event successNodeResponse(
    bool success,
    uint256 precipMM
  );

  event successPrice(
    bool success,
    uint256 price
  );

  uint256 public payment;

  constructor(
    address payable _buyer,
    string[] memory _location,
    uint256 _gmtOffset,
    string memory _date,
    uint256 _expired,
    string[] memory _times,
    // string memory _timesString,
    uint256  _price,
    uint256  _rate,
    uint256 _linkAmount,
    address _link,
    address payable _manager) public payable {

    buyer = _buyer;
    nameLocation = _location[0];
    location = _location[1];
    date = _date;
    expired = _expired; 
    price = _price;
	rate = _rate;
    linkAmount = _linkAmount;
    manager = _manager;
    gmtOffset= _gmtOffset;
    times = _times;
    deploymentTime = block.timestamp;

    if (_link == address(0)) {
      setPublicChainlinkToken();
      payment = 1 * LINK;
    } else {
      setChainlinkToken(_link);
      payment = 1;
    }
    setPublicChainlinkToken();

    setChainlinkOracle(ORACLE_WEATHER);
  }

  modifier buyerContract(){
    require(address(this) == msg.sender || buyer == msg.sender,"Unauthorised , must be buyer");
    _;
  }

  modifier onlyManager(){
	require(msg.sender == manager, "Unauthorised , must be manager");
	_;
  }
  

  function queryPrice() public {
    Chainlink.Request memory req = buildChainlinkRequest(JOB_ID_PRICE, address(this), this.fulfillPrice.selector);
    req.add("get", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD");
    req.add("path", "USD");
  	req.addInt("times", 100);
    sendChainlinkRequestTo(ORACLE_PRICE, req, payment);
  }

  function fulfillPrice(bytes32 _requestId, uint256 _etherPrice) public recordChainlinkFulfillment(_requestId) {
    linkAmount--;
    emit successPrice(true, _etherPrice);
    etherPrice = _etherPrice;
  }

  function queryWeather() public  {
    require(paid == false && isQueryWeather == false && (now + gmtOffset) > expired);
    uint arrayLength = times.length;
    for (uint i=0; i<arrayLength; i++) {
      Chainlink.Request memory req = buildChainlinkRequest(JOB_ID_WEATHER, address(this), this.fulfillWeather.selector);
      req.add("q", location);
      req.add("date", date);
      req.add("tp", "1");
      bytes memory s;
      s = abi.encodePacked("data.weather.0.hourly.");
      s = abi.encodePacked(s, times[i]);
      s = abi.encodePacked(s, ".precipMM");
      string memory path = string(s);
      req.add("copyPath", path);
      req.addInt("times", 100);
      sendChainlinkRequestTo(chainlinkOracleAddress(), req, payment);
    }
    
    isQueryWeather = true;
  }

  function fulfillWeather(bytes32 _requestId, uint256 _precipMM ) public recordChainlinkFulfillment(_requestId){
    linkAmount--;
    emit successNodeResponse(true, _precipMM);
    if(_precipMM >= 100){
      totalRainyHours++;
    }
    hourlyState.push(_precipMM);
  }
  
  function getAllTotalRainyHours() public view returns(uint256[] memory) {
    return hourlyState;
  }

  function payInsurance() public payable {
    require(paid == false);
    require(isQueryWeather == true);
    require(totalRainyHours > 0);

		compensation = (price * totalRainyHours / times.length) + price + (rate * price / 100);

		require(msg.value + address(this).balance >= compensation);
        buyer.transfer(compensation);
		paid = true;
  }

  function withDrawAllEther() public payable onlyManager {
    manager.transfer(address(this).balance);
  }

  function withDrawAllLINK() public onlyManager {
    require(linkAmount > 0);
    LinkTokenInterface link = LinkTokenInterface(0x20fE562d797A42Dcb3399062AE9546cd06f63280);
    link.transfer(manager, linkAmount * LINK);
    linkAmount = 0;
  }

  function getLINKBalance() public view onlyManager returns (uint256){
    return linkAmount;
  }

  function getBalance() public view returns (uint256){
	return address(this).balance;
  }
  
  function getTimes() public view returns (string[] memory){
	return times;
  }
  
  function getChainlinkToken() public returns (uint256) {
    amountTokenLink = LinkTokenInterface(chainlinkTokenAddress()).balanceOf(address(this));
    return amountTokenLink;   
  }
  
  function() external payable {}
}