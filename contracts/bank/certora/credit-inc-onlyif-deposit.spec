// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:credit-inc-onlyif-deposit.spec
// https://prover.certora.com/output/454304/16a75bee5db64ff8bd91089f1dce3921?anonymousKey=92ae20ef5fa82cb9b8a2a477875b797007dd3620

// if the credit of a user A is increased after a transaction [of the Bank contract], then that transaction must be a deposit() where A is the sender

rule credit_inc_onlyif_deposit {
    env e; 
    method f;
    calldataarg args;
    address a;

    require e.msg.sender != currentContract;
    require a != e.msg.sender;
    require a != currentContract;

    mathint old_a_credit = currentContract.credits[a];
    f(e, args);
    mathint new_a_credit = currentContract.credits[a];

    assert new_a_credit > old_a_credit => (f.selector == sig:deposit().selector && e.msg.sender == a);
}
