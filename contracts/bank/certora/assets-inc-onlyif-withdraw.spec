// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:assets-inc-onlyif-withdraw.spec
// https://prover.certora.com/output/454304/193fb8a752bd4a9591ab91a6372d66c2?anonymousKey=9db1fbf8838611ddf0c5f10996ade2ce43cb8ebe

// if the assets of a user A are increased after a transaction [of the Bank contract], then that transaction must be a withdraw() where A is the sender

rule assets_inc_onlyif_withdraw {
    env e; 
    method f;
    calldataarg args;
    address a;

    require e.msg.sender != currentContract;
    require a != currentContract;

    mathint old_a_balance = nativeBalances[a];
    f(e, args);
    mathint new_a_balance = nativeBalances[a];

    assert new_a_balance > old_a_balance => (f.selector == sig:withdraw(uint).selector && e.msg.sender == a);
}
