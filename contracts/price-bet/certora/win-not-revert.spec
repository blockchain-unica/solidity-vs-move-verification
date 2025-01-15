// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol Oracle.sol --verify Pricebet:win-not-revert.spec --link Pricebet:oracle=Oracle
// 

// a transaction win() does not revert if:
// 1) the deadline has not expired, and
// 2) the sender is the player, and 
// 3) the oracle exchange rate is greater or equal to the bet exchange rate.

using Oracle as oracle;

rule win_not_revert {
    env e;

    require 
        e.msg.value == 0 &&
        e.block.number < currentContract.deadline &&
        e.msg.sender == currentContract.player &&
        oracle.exchange_rate >= currentContract.exchange_rate;
    
    win@withrevert(e);
    assert !lastReverted;
}
