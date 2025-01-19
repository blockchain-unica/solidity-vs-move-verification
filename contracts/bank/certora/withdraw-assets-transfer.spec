// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:withdraw-assets-transfer.spec
// https://prover.certora.com/output/454304/ce0926b7367247a49cb547ffc30be433?anonymousKey=71d8c4b532ce6cee59c732a0d573aae8e9633b88

// after a successful withdraw(amount), exactly amount units of T pass from the control of the contract to that of the sender.

rule withdraw_assets_transfer {
    env e;
    uint256 amount;

    mathint old_user_balance = nativeBalances[e.msg.sender];
    withdraw(e,amount);
    mathint new_user_balance = nativeBalances[e.msg.sender];

    assert new_user_balance == old_user_balance + to_mathint(amount);
}
