// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:withdraw-revert.spec

// withdraw-revert: a transaction withdraw(amount) aborts if:
// 1) amount is more than the balance of the transaction sender, or 
// 2) the sender is not the owner.owner, or 
// 3) the state is not IDLE.

rule withdraw_revert {
    env e;

    calldataarg callargs;

    // TODO
    require e.msg.sender != currentContract.recovery;
    withdraw@withrevert(e, callargs);
    assert lastReverted;
}
