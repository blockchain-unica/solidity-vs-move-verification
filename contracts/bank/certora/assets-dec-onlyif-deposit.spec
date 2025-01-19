// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:assets-dec-onlyif-deposit.spec
// https://prover.certora.com/output/454304/344a4e7b20d84b41b8323c25ac8992e7?anonymousKey=e22b2c88bf5697a204e895a4b88045a85c6c871d

// if the assets of a user A are decreased after a transaction, 
// then that transaction must be a deposit() where A is the sender

rule assets_dec_onlyif_deposit {
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

    assert new_a_balance < old_a_balance => (f.selector == sig:deposit().selector && e.msg.sender == a);
}
