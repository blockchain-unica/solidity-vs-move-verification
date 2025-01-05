// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:deposit-assets-credit.spec
// https://prover.certora.com/output/454304/a36122886f7a49e5826e4d42a69e159a?anonymousKey=d457ef88f18627eac72219360c4fbc0c97bb8ffc

// after a successful deposit(amount), the users’ credit is increased by exactly amount units of T.

rule deposit_assets_credit {
    env e;
    mathint amount = e.msg.value;

    mathint old_user_credit = currentContract.credits[e.msg.sender];
    deposit(e);
    mathint new_user_credit = currentContract.credits[e.msg.sender];

    assert new_user_credit == old_user_credit + amount;
}
