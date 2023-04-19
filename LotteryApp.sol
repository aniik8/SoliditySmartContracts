// SPDX-License-Identifier:MIT
pragma solidity >= 0.8.8;

contract Lottery{
    address public manager;
    address payable[] public participants;
    constructor(){
            manager = msg.sender;
    }
    receive() external payable{
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }
    function getWinner() public{
        require(participants.length >= 3);
        require(msg.sender == manager);
        uint num = random();
        uint index = num % participants.length;
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}


// function - constructor, add member in array if pay 1 ether get balance of contract generate random transfer 
// based on the random number generated.