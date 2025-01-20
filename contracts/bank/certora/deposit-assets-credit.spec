// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:deposit-assets-credit.spec
// https://prover.certora.com/output/454304/9e818d9e82814788a6e58c53edb09cd1?anonymousKey=ddd6073279e7d9c0a7462c3dd1e409752a93e538

// after a successful deposit(amount), the users’ credit is increased by exactly amount units of T.

rule deposit_assets_credit {
    env e;
    mathint amount = e.msg.value;

    mathint old_user_credit = currentContract.credits[e.msg.sender];
    deposit(e);
    mathint new_user_credit = currentContract.credits[e.msg.sender];

    assert new_user_credit == old_user_credit + amount;
}
