// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Sandwich {
    mapping (address => bool) sandwich_buyers;
    uint256 public sandwich_price = 2 ether;
    address public contract_owner;
    address public contract_address;
    bool payment_status = false;

    // contract start constructor
    constructor() {
        contract_owner = msg.sender;
        contract_address = address(this);
    }

    // get a sandwich buyer
    function getBuyer(address _addr) public view returns(bool) {

        // check that the sender of the message is the owner of the contract
        require(contract_owner == msg.sender, "You are not an contract owner!");
        
        return sandwich_buyers[_addr];
    }

    // add new sandwich buyer
    function addBuyer(address _addr) public {

        // check that the sender of the message is the owner of the contract
        require(contract_owner == msg.sender, "You are not an contract owner!");

        // append new buyer
        sandwich_buyers[_addr] = true;
    }

    // get contract balance
    function getBalance() public view returns(uint256) {
        return contract_address.balance;
    }

    // withdraw all from contract balance to contract owner
    function withdrawAll() public {

        // check that the sender of the message is the owner of the contract
        require(contract_owner == msg.sender && payment_status && contract_address.balance > 0, "Rejected");

        address payable receiver = payable(msg.sender);
        
        // transfer all contract balance to contract owner
        receiver.transfer(contract_address.balance);
    }

    // check incoming transaction
    receive() external payable {
        require(sandwich_buyers[msg.sender] && msg.value <= sandwich_price && !payment_status, "Rejected");

        if(contract_address.balance == sandwich_price) {
            payment_status = true;
        }
    }
}