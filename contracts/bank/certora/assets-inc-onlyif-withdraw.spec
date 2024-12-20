// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:assets-inc-onlyif-withdraw.spec
// https://prover.certora.com/output/454304/9b7463b4f0b243d988afad90d3d1a0ed?anonymousKey=1a10fbe046b5a25475f233f3872166099c063268

// if the assets of a user A are increased after a transaction [of the Bank contract], then that transaction must be a withdraw() where A is the sender

rule assets_inc_onlyif_withdraw {
    env e; 
    method f;
    calldataarg args;
    address a;

    require e.msg.sender != currentContract;
    require a != e.msg.sender;
    require a != currentContract;

    mathint old_a_balance = nativeBalances[a];
    f(e, args);
    mathint new_a_balance = nativeBalances[a];

    assert new_a_balance > old_a_balance => (f.selector == sig:withdraw(uint).selector && e.msg.sender == a);
}
