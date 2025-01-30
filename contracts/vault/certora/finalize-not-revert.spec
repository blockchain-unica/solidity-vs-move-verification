// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-not-revert.spec
// https://prover.certora.com/output/454304/701d96d1926d46cfb6465e2b4d54c84c?anonymousKey=ac2a355021acbd15b33c8a89f7c42ad3a244f2a2

// a finalize() transaction does not abort if:
// 1) it is sent by the owner, 
// 2) in state REQ, and 
// 3) at least wait_time time units have elapsed after request_timestamp

rule finalize_not_revert {
    env e;

    require 
        e.msg.sender == currentContract.owner &&
        currentContract.state == Vault.States.REQ &&
        e.block.number >= currentContract.request_time + currentContract.wait_time &&
        e.msg.value == 0; // the sender must not transfer any ETH

    finalize@withrevert(e);
    assert !lastReverted;
}
