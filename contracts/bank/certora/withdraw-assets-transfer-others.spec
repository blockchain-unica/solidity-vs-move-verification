// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:withdraw-assets-transfer-others.spec
// https://prover.certora.com/output/454304/48841589c65f43b985892a71bf4da745?anonymousKey=95afcfd523ec469fe9e447421ed42fb83192e421

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

    assert new_user_balance == old_user_balance + to_mathint(amount);
}
