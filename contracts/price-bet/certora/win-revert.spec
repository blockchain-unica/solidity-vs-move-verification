// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol Oracle.sol --verify Pricebet:win-revert.spec --link Pricebet:oracle=Oracle
// https://prover.certora.com/output/454304/469fc962aa4b4716875bf50b25b34942?anonymousKey=f4d6f458b6e42be254705aaa44d273da40c39775

// a transaction win() reverts if:
// 1) the deadline has expired, or 
// 2) the sender is not the player, or 
// 3) the oracle exchange rate is smaller than the bet exchange rate.

using Oracle as oracle;

rule win_revert {
    env e;

    require 
        e.block.number > currentContract.deadline ||
        e.msg.sender != currentContract.player ||
        oracle.exchange_rate < currentContract.exchange_rate;
    
    win@withrevert(e);
    assert lastReverted;
}
