// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:cancel-not-revert.spec
// https://prover.certora.com/output/454304/1fb1bf3be12f44eaa8f1e374e68845cb?anonymousKey=5cee1e8abdfb4a7a34275035b6ac3ce83a8f1bc9

// a transaction cancel() does not abort if: 
// 1) the signer uses the recovery key, and
// 2) the state is REQ.

rule cancel_not_revert {
    env e;

    require 
        e.msg.sender == currentContract.recovery &&
        currentContract.state == Vault.States.REQ &&
        e.msg.value == 0; // the sender must not transfer any ETH

    cancel@withrevert(e);
    assert !lastReverted;
}
