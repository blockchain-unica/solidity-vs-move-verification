// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol --verify Pricebet:timeout-revert.spec
// https://prover.certora.com/output/454304/d876c6bd62844a579955e72dfa9cd224?anonymousKey=4c89d707eee454e98952c8170fc2e2b2c453a53

// a transaction timeout() reverts if the deadline has not passed yet

rule timeout_revert {
    env e;

    require 
        e.block.number < currentContract.deadline;
    
    timeout@withrevert(e);
    assert lastReverted;
}
