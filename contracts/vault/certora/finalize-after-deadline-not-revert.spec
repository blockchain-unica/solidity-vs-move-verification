// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-after-deadline-not-revert.spec
// https://prover.certora.com/output/454304/cd20d22a205c491dba47e916c28fc42e?anonymousKey=30553cfaa6d93004cf231a2326657751f0fe4f62

// a finalize() transaction does not abort if it is sent by the owner, in state REQ, and after wait_time time units have elapsed after a successful withdraw().

rule finalize_after_deadline_not_revert {
    env e1;
    
    address addr;
    uint amt;
    withdraw(e1, addr, amt);

    env e2;

    require 
        e2.msg.sender == currentContract.owner && 
        currentContract.state == Vault.States.REQ &&
        e2.block.number >= e1.block.number + currentContract.wait_time;

    finalize@withrevert(e2);

    assert !lastReverted;
}
