// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol --verify Pricebet:timeout-not-revert.spec
// https://prover.certora.com/output/454304/eb12391ae98148f9bcfb815a9b152279?anonymousKey=8ef063741e76ba65ef0417196b42fc9ce8233e0b

// a transaction timeout() does not revert if the deadline has passed

rule timeout_not_revert {
    env e;

    require 
        e.msg.value == 0 &&
        e.block.number >= currentContract.deadline;
    
    timeout@withrevert(e);
    assert !lastReverted;
}
