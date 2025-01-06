// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:withdraw-not-revert.spec
// https://prover.certora.com/output/454304/fb870ca938f04ff3904e862aa0572318?anonymousKey=25152ef1ba866da32a6d68028a43b06d7d3bedc3

// withdraw-not-revert: a transaction withdraw(amount) does not abort if:
// 1) amount is less than or equal to the contract balance, and 
// 2) the sender is the owner, and 
// 3) the state is IDLE.

rule withdraw_not_revert {
    env e;
    uint amt;
    address rcv;

    require 
        amt <= nativeBalances[currentContract] &&
        e.msg.sender == currentContract.owner && 
        currentContract.state == Vault.States.IDLE &&
        e.msg.value == 0; // the sender must not transfer any ETH

    withdraw@withrevert(e, rcv, amt);
    assert !lastReverted;
}
