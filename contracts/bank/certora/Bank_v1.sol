//SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.2;

contract Bank {
    mapping (address => uint) credits;

    function deposit() public payable {
        credits[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(amount > 0);
        require(amount <= credits[msg.sender]);

        credits[msg.sender] -= amount;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
    }
}