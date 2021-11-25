
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// This contract will do allow admin send token
// Also address can send token between themselves
contract Token {
    
  address minter;
  uint public totalSupply = 10000;

  address[] tokenHolders;

  mapping(address => uint) token;
  
  event TokenSentToAddress (address _receiver, uint amount);

  constructor() {
      minter = msg.sender;
      token[msg.sender] = totalSupply;
  }

  modifier Ownable() {
     require(msg.sender == minter,"Only contact creator is allow to send token");
    _; 
  }

  error InsufficientTokenBalance (uint256 tokenRequested, uint256 availableToken);
  
  // token sent to addresses from Minter
  function tokenSentToAddressByMinter(address _address, uint256 amount) public Ownable {
    if(amount > token[msg.sender]) {
      revert InsufficientTokenBalance(amount, token[msg.sender]);
   }
    token[msg.sender] -= amount;
    token[_address] += amount;
// keep list of address sent to
    tokenHolders.push(_address);
    emit TokenSentToAddress(_address, amount);  
  }
// send token between addresses
  function sendTokenBetweenAddressess(address _address, uint256 amount) public {
     if(amount > token[msg.sender]) {
      revert InsufficientTokenBalance(amount, token[msg.sender]);
   }
    token[msg.sender] -= amount;
    token[_address] += amount;
    
    emit TokenSentToAddress(_address, amount);
  }

  // // get current balance 
  function getAvailableBalance() public view returns(uint) {
           return token[msg.sender]; 
  }
  
  function getListOfAddressSentByMinter () public view returns(address[] memory  ) {
    return tokenHolders;
  }

}
