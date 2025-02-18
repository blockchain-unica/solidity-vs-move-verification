// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:withdraw-assets-transfer-eav.spec
// https://prover.certora.com/output/454304/1f12e6829bf6459cbd984e7a629889d4?anonymousKey=fbd1d60f24b5102ed092142aec69bd5282e0c2e5

// after a successful withdraw(amount) performed by an EOA, exactly amount units of T pass from the control of the contract to that of the sender.

rule withdraw_assets_transfer_eav {
    env e;
    uint256 amount;

    // the sender is an EAV
    require (e.msg.sender == e.tx.origin);

    mathint old_user_balance = nativeBalances[e.msg.sender];
    withdraw(e,amount);
    mathint new_user_balance = nativeBalances[e.msg.sender];

    assert new_user_balance == old_user_balance + to_mathint(amount);
}
