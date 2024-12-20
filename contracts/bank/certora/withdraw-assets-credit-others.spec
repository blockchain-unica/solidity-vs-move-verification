// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:withdraw-assets-credit-others.spec
// https://prover.certora.com/output/454304/64c5a390f3544d2d89a2269178b012eb?anonymousKey=1ecc03caac7c7a5591d739cdf0f587a438e04f10

// after a successful withdraw(amount), the credits of any user but the sender are preserved.

rule withdraw_assets_credit {
    env e;
    uint256 amount;
    address a; // other address

    require a != e.msg.sender;

    mathint old_other_credit = currentContract.credits[a];
    withdraw(e,amount);
    mathint new_other_credit = currentContract.credits[a];

    assert new_other_credit == old_other_credit;
}
