// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:credit-inc-onlyif-deposit.spec
// https://prover.certora.com/output/454304/e71aab1242c145828256ccd03f0a2955?anonymousKey=3c4006b3baa961608ec36683d5c9560f74dd48ab

// if the credit of a user A is increased after a transaction, 
// then that transaction must be a deposit() where A is the sender

rule credit_inc_onlyif_deposit {
    env e; 
    method f;
    calldataarg args;
    address a; // user whose credit is increased

    require e.msg.sender != currentContract;
    require a != e.msg.sender;
    require a != currentContract;

    mathint old_a_credit = currentContract.credits[a];
    f(e, args);
    mathint new_a_credit = currentContract.credits[a];

    assert new_a_credit > old_a_credit => 
        (f.selector == sig:deposit().selector && e.msg.sender == a);
}
