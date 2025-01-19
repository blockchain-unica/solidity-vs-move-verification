// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:withdraw-assets-credit.spec
// https://prover.certora.com/output/454304/57d856c2452846a4a0fda0e6c8fb50a7?anonymousKey=e4875fb57901e34b102819de0653b682a7bd06f8

// after a successful withdraw(amount), exactly amount units of T pass from the control of the contract to that of the sender.

rule withdraw_assets_credit {
    env e;
    uint256 amount;

    mathint old_user_credit = currentContract.credits[e.msg.sender];
    withdraw(e,amount);
    mathint new_user_credit = currentContract.credits[e.msg.sender];

    assert new_user_credit == old_user_credit - to_mathint(amount);
}
