// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:deposit-not-revert.spec
// https://prover.certora.com/output/454304/f56188a234dd4aaeb2cdfb566f5d0571?anonymousKey=1a5fb788ed62215bbb9e6ca3fd172d88c1dc64a1

// (up-to overflows) a transaction deposit(amount) does not abort 
// if amount is less than or equal to the transaction sender’s T balance and operation limit.

rule deposit_not_revert {
    env e;

    require 0 < e.msg.value && e.msg.value <= nativeBalances[e.msg.sender];
    require currentContract.credits[e.msg.sender] + e.msg.value < max_uint;
    require e.msg.sender==currentContract.owner || e.msg.value <= currentContract.opLimit;

    // The following require does not affect verification outcome (not enough ETH?)
    // require(nativeBalances[currentContract] + e.msg.value < max_uint);

    deposit@withrevert(e);

    assert !lastReverted;
}

