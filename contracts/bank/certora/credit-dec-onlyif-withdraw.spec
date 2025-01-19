// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:credit-dec-onlyif-withdraw.spec
// https://prover.certora.com/output/454304/32c2cc84a9eb4709abc159b87ecc9ca9?anonymousKey=161687e7943c98c9ee69867d07b999760503c342

// if the credit of a user A is decreased after a transaction [of the Bank contract], then that transaction must be a withdraw() where A is the sender

rule credit_dec_onlyif_withdraw {
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

    assert new_a_credit < old_a_credit => (f.selector == sig:withdraw(uint).selector && e.msg.sender == a);
}
