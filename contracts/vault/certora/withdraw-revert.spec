// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:withdraw-revert.spec
// https://prover.certora.com/output/454304/d62b6c7ddc7e43e3b18d325cd1ee9c38?anonymousKey=a905447ebc44e79661a3d92f957bb19d969e6de8

// withdraw-revert: a transaction withdraw(amount) aborts if:
// 1) amount is more than the contract balance, or 
// 2) the sender is not the owner, or 
// 3) the state is not IDLE.

rule withdraw_revert {
    env e;
    uint amt;
    address rcv;

    require 
        amt > nativeBalances[currentContract] ||
        e.msg.sender != currentContract.owner || 
        currentContract.state != Vault.States.IDLE;

    withdraw@withrevert(e, rcv, amt);
    assert lastReverted;
}
