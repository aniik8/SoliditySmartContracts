// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Party {
    address[] rsvps;
    uint256 deposit;
	constructor(uint256 _deposit){
     deposit = _deposit;
    }
    function isRsvp(address _address) internal view returns(bool){
        for(uint i = 0; i < rsvps.length;i++){
            if(_address == rsvps[i])
                return true;
        }
    }

    function rsvp() external payable{
      require(msg.value == deposit, " not enough");
      require(isRsvp(msg.sender) == false, " not valid addr");
      rsvps.push(msg.sender);
    }
    
    function payBill(address _address, uint256 amount) external{
        (bool val,) = _address.call{value : amount}("");
        require(val);
        uint share = address(this).balance / rsvps.length;
        for(uint i = 0; i < rsvps.length; i++){
            (bool success, ) = rsvps[i].call{value : share}("");
            require(success);
        }
    }
}