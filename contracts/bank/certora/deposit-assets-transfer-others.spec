// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:deposit-assets-transfer-others.spec
// https://prover.certora.com/output/454304/c8c931defaa149639cd5ac58fbd24398?anonymousKey=184780f96f0c97e82fdc37f4f599ef9af02a4c2f

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
