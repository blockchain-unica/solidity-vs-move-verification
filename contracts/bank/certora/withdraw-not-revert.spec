// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:withdraw-not-revert.spec
// https://prover.certora.com/output/454304/7d3339b03a9a4ad8a87c954912528715?anonymousKey=6f9f74a444504532ad9e9739c04c3bc08268af43

// a transaction withdraw(amount) does not abort if amount is less or equal to 
// the transaction sender's credit and operation limit .

rule withdraw_not_revert {
    env e;
    uint amount;

    require 0 <= amount;
    require amount <= currentContract.credits[e.msg.sender];
    require e.msg.sender != currentContract;
    require e.msg.sender==currentContract.owner || amount <= currentContract.opLimit;

    withdraw@withrevert(e, amount);

    assert !lastReverted;
}
