// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol --verify Pricebet:join-revert.spec
// https://prover.certora.com/output/454304/8010023accdb448d89f3b91170082bbd?anonymousKey=df9aa3df77469d8d2b27428beb01583ec68eb90b

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
