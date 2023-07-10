// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSig {
    address[] public owners;
    uint public transactionCount;
    uint public required;

    struct Transaction {
        address destination;
        uint value;
        bool executed;
        bytes data;
    }

    mapping(uint => Transaction) public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;

    receive() payable external {
        
    }

    function isConfirmed(uint transactionId) public view returns(bool) {
        return getConfirmationsCount(transactionId) >= required;
    }

    function getConfirmationsCount(uint transactionId) public view returns(uint) {
        uint count;
        for(uint i = 0; i < owners.length; i++) {
            if(confirmations[transactionId][owners[i]]) {
                count++;
            }
        }
        return count;
    }

    function isOwner(address addr) private view returns(bool) {
        for(uint i = 0; i < owners.length; i++) {
            if(owners[i] == addr) {
                return true;
            }
        }
        return false;
    }

    function submitTransaction(address dest, uint value, bytes calldata _data) external {
        uint id = addTransaction(dest, value, _data);
        confirmTransaction(id);
    }

    function confirmTransaction(uint transactionId) public {
        require(isOwner(msg.sender));
        confirmations[transactionId][msg.sender] = true;
        if(isConfirmed(transactionId))
            executeTransaction(transactionId);
        
    }

    function addTransaction(address destination, uint value, bytes calldata _data) internal returns(uint) {
        transactions[transactionCount] = Transaction(destination, value, false, _data);
        transactionCount += 1;
        return transactionCount - 1;
    }
    function executeTransaction(uint _id) public{
        require(confirmations[_id][msg.sender] == true);
        require(isConfirmed(_id));
        (bool success, ) = transactions[_id].destination.call{value : transactions[_id].value}(transactions[_id].data);
        require(success);
        transactions[_id].executed = true;
    }
    constructor(address[] memory _owners, uint _confirmations) {
        require(_owners.length > 0);
        require(_confirmations > 0);
        require(_confirmations <= _owners.length);
        owners = _owners;
        required = _confirmations;
    }
}
