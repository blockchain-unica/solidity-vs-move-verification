// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-assets-transfer.spec
// https://prover.certora.com/output/454304/fcce3b161c1f4d8ebb77562b1952798e?anonymousKey=69a737d7360621ded902b4ce175fa04df3004df5

// after a successful finalize(), exactly amount units of T pass from the control of the contract to that of the sender.

rule finalize_asset_transfer {
    env e;
    uint256 amount;

    mathint old_user_balance = nativeBalances[e.msg.sender];

    finalize(e);

    mathint new_user_balance = nativeBalances[e.msg.sender];
    assert new_user_balance == old_user_balance + to_mathint(currentContract.amount);
}