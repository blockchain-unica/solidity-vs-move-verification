
// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol --verify Pricebet:join-revert.spec
// 

// a transaction join() reverts if: 
// 1) the amount sent is different from initial_pot, or 
// 2) another player has already joined

rule join_revert {
    env e;

    require 
        e.msg.value != currentContract.initial_pot ||
        currentContract.player != 0;

    join@withrevert(e);
    assert lastReverted;
}
