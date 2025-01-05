// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:deposit-assets-credit-others.spec
// https://prover.certora.com/output/454304/c115d45e058b40efa196a52e11560930?anonymousKey=a727d89ed47d890254b291126975c74af8c6e4f5

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
