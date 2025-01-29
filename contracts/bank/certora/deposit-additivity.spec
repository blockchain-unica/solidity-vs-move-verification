// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:deposit-additivity.spec
// https://prover.certora.com/output/454304/46d1126c576246f1b37e86111d28b6a8?anonymousKey=94662de276e859a8eb1fcd9b0f32f8cb42c554af

// two successful deposits of n1 and n2 units of T performed by the same sender are equivalent 
// to a single deposit of n1+n2 units of T, if n1+n2 is less than or equal to the sender's operation limit

  
rule deposit_additivity {
    env e1;
    env e2;
    env e3;

    storage initial = lastStorage;

    require e1.msg.sender == e2.msg.sender;
    require e1.msg.value + e2.msg.value <= currentContract.opLimit;

    deposit(e1);
    deposit(e2);

    storage s12 = lastStorage;

    require e3.msg.sender == e1.msg.sender;
    require e3.msg.value == e1.msg.value + e2.msg.value;

    deposit(e3) at initial;
    storage s3 = lastStorage;

    // checks equality of the following:
    // - the values in storage for all contracts,
    // - the balances of all contracts,
    // - the state of all ghost variables and functions
    // https://docs.certora.com/en/latest/docs/cvl/expr.html#comparing-storage
    // however, the experiments show that also the account balances are checked

    assert s12 == s3;
}
