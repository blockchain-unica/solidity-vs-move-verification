// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >= 0.8.2;
import "ReentrancyGuard.sol"; // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.8.2/contracts/security/ReentrancyGuard.sol

/// @custom:version non-reentrant `withdraw`.

pragma solidity >= 0.8.2;

contract Bank is ReentrancyGuard {
    mapping (address => uint) credits;

    function deposit() public payable {
        credits[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public nonReentrant {
        require(amount > 0);
        require(amount <= credits[msg.sender]);

        credits[msg.sender] -= amount;

        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
    }
}