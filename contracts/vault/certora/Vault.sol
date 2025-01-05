// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >= 0.8.2;

contract Vault {
    enum States{IDLE, REQ}

    address owner;
    address recovery;
    uint wait_time;

    address receiver;
    uint request_time;
    uint amount;
    States state;

    constructor (address payable recovery_, uint wait_time_) payable {
       	require(msg.sender != recovery_);
        require(wait_time_ > 0);
        owner = msg.sender;
        recovery = recovery_;
        wait_time = wait_time_;
        state = States.IDLE;
    }

    receive() external payable { }

    //  IDLE -> REQ
    function withdraw(address rcv, uint amt) public {
        require(state == States.IDLE);
        require(amt <= address(this).balance);
        require(msg.sender == owner);
        request_time = block.number;
        amount = amt;
        receiver = rcv;
        state = States.REQ;
    }

    // REQ -> IDLE
    function finalize() public { 
        require(state == States.REQ);
        require (block.number >= request_time + wait_time);
        require (msg.sender == owner);
        state = States.IDLE;	
        (bool succ,) = receiver.call{value: amount}("");
        require(succ);
    }

    // REQ -> IDLE
    function cancel() public {
        require(state == States.REQ);
        require (msg.sender == recovery);
        state = States.IDLE;
    }
}
