// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:deposit-assets-transfer-others.spec
// https://prover.certora.com/output/454304/5994f171fecf4082bdeebee84b1d75fa?anonymousKey=862fc740a171f642c532a1103efef87ee2c01ecd

// after a successful deposit(amount), the assets controlled by any user but the sender are preserved.

rule deposit_assets_transfer_others {
    env e; 
    address a; // other address

    require a != e.msg.sender;
    require a != currentContract;

    mathint old_other_balance = nativeBalances[a];
    deposit(e);
    mathint new_other_balance = nativeBalances[a];

    assert new_other_balance == old_other_balance;
}
