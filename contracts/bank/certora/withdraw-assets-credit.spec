// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:withdraw-assets-credit.spec
// https://prover.certora.com/output/454304/55264a9ca0e44e2dbfa751188c45d4c7?anonymousKey=0120e30fd56ddcb2e161ef7b87919ae9bae91024

// after a successful withdraw(amount), exactly amount units of T pass from the control of the contract to that of the sender.

rule withdraw_assets_credit {
    env e;
    uint256 amount;

    mathint old_user_credit = currentContract.credits[e.msg.sender];
    withdraw(e,amount);
    mathint new_user_credit = currentContract.credits[e.msg.sender];

    assert new_user_credit == old_user_credit - to_mathint(amount);
}
