// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:deposit-reversibility.spec
// https://prover.certora.com/output/454304/2540129ba16f4c5f969b4e2b1ce0dd2e?anonymousKey=8254a3677d170fcad31881041217538669dc0b6d

// the effect of a deposit(amount) is reverted by an immediately subsequent withdraw(amount)
  
rule deposit_reversibility {
    env e1;
    env e2;

    storage initial = lastStorage;

    require e1.msg.sender == e2.msg.sender;
    require e1.msg.value <= currentContract.opLimit;

    deposit(e1);

    storage s12 = lastStorage;

    withdraw(e2, e1.msg.value);

    storage final = lastStorage;

    // checks equality of the following:
    // - the values in storage for all contracts,
    // - the balances of all contracts,
    // - the state of all ghost variables and functions
    // https://docs.certora.com/en/latest/docs/cvl/expr.html#comparing-storage
    // however, the experiments show that also the account balances are checked

    assert initial == final;
}
