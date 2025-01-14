//SPDX-License-Identifier: GPL-3.0-only
pragma solidity >= 0.8.2;

import "./Oracle.sol";

contract Pricebet {
    uint256 initial_pot;
    uint256 deadline;
    uint256 exchange_rate;
    address oracle;
    address payable owner;
    address payable player;

    constructor(address _oracle, uint256 timeout, uint256 _exchange_rate) payable {
        require (msg.value > 0);
        initial_pot = msg.value;
        owner = payable(msg.sender);
        oracle = _oracle;
        deadline = block.number + timeout;
        exchange_rate = _exchange_rate;
    }

    function join() public payable {
        require(msg.value == initial_pot);
        require(player == address(0));
        player = payable(msg.sender);
    }

    function win() public {
        require(block.number < deadline);
        require(msg.sender == player);

        Oracle oracle_instance = Oracle(oracle);
        require(oracle_instance.get_exchange_rate() >= exchange_rate);

        (bool success, ) = player.call{value: address(this).balance}("");
        require(success);
    }

    function timeout() public {
        require(block.number >= deadline);

        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }

}