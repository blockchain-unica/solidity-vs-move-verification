// SPDX-License-Identifier: GPL-3.0-only

rule withdraw_revert {
    env e;
    uint amount;

    require (amount == 0 || amount > currentContract.balances[e.msg.sender]);

    withdraw@withrevert(e, amount);

    assert lastReverted;
}
