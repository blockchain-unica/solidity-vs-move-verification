// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:assets-inc-onlyif-withdraw.spec
// https://prover.certora.com/output/454304/b817317f85ab462584b4ac7494c0ef1d?anonymousKey=771f7d57fcddd622920438e0f462c073bd78971e

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
