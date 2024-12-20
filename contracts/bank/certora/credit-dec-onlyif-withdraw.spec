// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:credit-dec-onlyif-withdraw.spec
// https://prover.certora.com/output/454304/96f8851d1cb0450da089748b9a2ee6ef?anonymousKey=fbe69c84e7f88e99a722ff0c5b127e6c5efb0597

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
