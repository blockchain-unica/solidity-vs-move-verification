// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:withdraw-not-revert.spec
// https://prover.certora.com/output/454304/9682187fb0fa454cb493a3f0e9ad0419?anonymousKey=d5cae82fb42dff6d383c04f6cf5f700425b36d20

// a transaction withdraw(amount) does not abort if amount is less or equal to the credit of the transaction sender.

rule withdraw_not_revert {
    env e;
    uint amount;

    require 0 <= amount;
    require amount <= currentContract.credits[e.msg.sender];
    require e.msg.sender != currentContract;

    withdraw@withrevert(e, amount);

    assert !lastReverted;
}
