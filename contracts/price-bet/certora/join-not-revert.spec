
// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol --verify Pricebet:join-not-revert.spec
// https://prover.certora.com/output/454304/dbdc536ced1046d284785b4fd15094d9?anonymousKey=5ee46bc052d32786f245853be5e833350c76b19d

// a transaction join() does not revert if: 
// 1) the amount sent is equal to the initial pot, and
// 2) no player has joined yet, and 
// 3) the sender has enough tokens.

rule join_not_revert {
    env e;

    require 
        nativeBalances[e.msg.sender] >= e.msg.value &&
        e.msg.value == currentContract.initial_pot &&
        currentContract.player == 0;

    join@withrevert(e);
    assert !lastReverted;
}
