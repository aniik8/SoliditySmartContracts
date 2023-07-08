// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Switch {
    address recipient;
    address owner;
    uint256 lastAction;
    constructor(address _address) payable{
        recipient = _address;
        owner = msg.sender;
        lastAction = block.timestamp;
    }
    function withdraw() external{
        require((block.timestamp - lastAction) >= 52 weeks);
        (bool success, ) = recipient.call{value : address(this).balance}("");
        require(success);
    }
    function ping() external{
        require(msg.sender == owner);
        lastAction = block.timestamp;
    }
}