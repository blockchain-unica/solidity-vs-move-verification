// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:deposit-assets-credit-others.spec
// https://prover.certora.com/output/454304/265b861c53494e74b626e016358c2c45?anonymousKey=3686e8955db7ecdc76558823c9e8818a63e39405

// after a successful deposit(amount), the credits of any user but the sender are preserved.

rule deposit_assets_credit_others {
    env e;
    address a;

    require a != e.msg.sender;

    mathint old_a_credit = currentContract.credits[a];
    deposit(e);
    mathint new_a_credit = currentContract.credits[a];

    assert new_a_credit == old_a_credit;
}
