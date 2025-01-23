// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:withdraw-finalize-not-revert.spec
// https://prover.certora.com/output/5934372/94881969328941a5bc30c2050e245675?anonymousKey=4b97f82e1b06056f3a022715b853ff1b0b4feaa2

// a finalize() transaction does not abort if it is sent by the owner, and after wait_time time units have elapsed after a successful withdraw() that has not been cancelled nor finalized.

rule finalize_after_withdraw_not_revert {
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
