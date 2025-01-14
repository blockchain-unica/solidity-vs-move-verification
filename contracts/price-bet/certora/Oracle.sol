//SPDX-License-Identifier: GPL-3.0-only
pragma solidity >= 0.8.2;

contract Oracle {
    address owner;
    uint exchange_rate;

    constructor(uint init_rate) {
        owner = msg.sender;
        exchange_rate = init_rate;
    }

    function get_exchange_rate() public view returns(uint) {
        return exchange_rate;
    }

    function set_exchange_rate(uint new_rate) public {
        require(msg.sender == owner);
        exchange_rate = new_rate;
    }
}