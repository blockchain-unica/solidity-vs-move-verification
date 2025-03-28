// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:assets-dec-onlyif-deposit.spec
// https://prover.certora.com/output/454304/7ed1e095a4f74d47970aa6e94d7c21ee?anonymousKey=3c547168cae8a6127801d3952d741c0e8687e4b9

// if the assets of a user A are decreased after a transaction, 
// then that transaction must be a deposit() where A is the sender

rule assets_dec_onlyif_deposit {
    env e; 
    method f;
    calldataarg args;
    address a;

    require e.msg.sender != currentContract;
    require a != currentContract;

    mathint old_a_balance = nativeBalances[a];
    f(e, args);
    mathint new_a_balance = nativeBalances[a];

    assert new_a_balance < old_a_balance => (f.selector == sig:deposit().selector && e.msg.sender == a);
}
