// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:withdraw-assets-transfer.spec
// https://prover.certora.com/output/454304/c9a388b3b7524a6f9101410e025e53a0?anonymousKey=b9a316643232b527efdf87750e18ec97c2102ad2

// after a successful withdraw(amount), exactly amount units of T pass from the control of the contract to that of the sender.

rule withdraw_assets_credit {
    env e;
    uint256 amount;

    mathint old_user_credit = currentContract.credits[e.msg.sender];
    withdraw(e,amount);
    mathint new_user_credit = currentContract.credits[e.msg.sender];

    assert new_user_credit == old_user_credit - to_mathint(amount);
}
