//SPDX-License-Identifier: GPL-3.0-only
pragma solidity >= 0.8.2;

import "./Oracle.sol";

contract PriceBet{
    uint256 initial_pot;
    uint256 deadline_block;
    uint256 exchange_rate;
    address oracle;
    address payable owner;
    address payable player;

    constructor(address _oracle, uint256 _deadline, uint256 _exchange_rate) payable {
        initial_pot = msg.value;
        owner = payable(msg.sender);
        oracle = _oracle;
        deadline_block = block.number + _deadline;
        exchange_rate = _exchange_rate;
    }

    function join() public payable {
        require(msg.value == initial_pot);
        require(player == address(0));
        player = payable(msg.sender);
    }

    function win() public {
        Oracle TheOracle = Oracle(oracle);
        require(block.number < deadline_block);
        require(msg.sender == player);
        require(TheOracle.get_exchange_rate() >= exchange_rate);
        (bool success, ) = player.call{value: address(this).balance}("");
        require(success);
    }

    function timeout() public {
        require(block.number >= deadline_block);
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success);
    }

}