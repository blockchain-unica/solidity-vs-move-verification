// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:withdraw-assets-transfer-others.spec
// https://prover.certora.com/output/454304/e44a23cf6fa347cb88e8453070a82385?anonymousKey=05fce07180bac5bd63ee54d378310b7d3fae8a81

// after a successful withdraw(amount), the assets controlled by any user but the sender are preserved.

rule withdraw_assets_transfer_others {
    env e;
    uint256 amount;
    address a; // other address

    require a != e.msg.sender;
    require a != currentContract;

    mathint old_user_balance = nativeBalances[a];
    withdraw(e,amount);
    mathint new_user_balance = nativeBalances[a];

    assert new_user_balance == old_user_balance;
}
