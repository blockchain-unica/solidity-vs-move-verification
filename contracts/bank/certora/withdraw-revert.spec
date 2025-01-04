// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:withdraw-revert.spec
// https://prover.certora.com/output/454304/738c3e36030943c4a8cd801bdbe9c868?anonymousKey=b385240ea3857d1f6584e6e6e9cf28bc4fb1f56e

// a transaction withdraw(amount) aborts if amount is more than the credit of the transaction sender.

rule withdraw_revert {
    env e;
    uint amount;

    require (amount == 0 || amount > currentContract.credits[e.msg.sender]);

    withdraw@withrevert(e, amount);

    assert lastReverted;
}
