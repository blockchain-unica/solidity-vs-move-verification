// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:deposit-revert.spec
// https://prover.certora.com/output/454304/c6e9ea53920540babd82d2ae41888f24?anonymousKey=0aa3f20c3aba2a3d57a5d2c0b5edea5bdd034cc5

 // a transaction deposit(amount) aborts if amount is more than the T balance of the transaction sender.

rule deposit_revert {
    env e;

    require(e.msg.value > nativeBalances[e.msg.sender]);
    deposit@withrevert(e);
    
    assert lastReverted;
}
