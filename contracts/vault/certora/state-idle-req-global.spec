// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:state-idle-req-global.spec
// https://prover.certora.com/output/454304/2eee02cadf2247b3a59b9678e199fa0d?anonymousKey=a88b1aa996325c8bea18da0667a668a580c4e589

// (in any blockchain state) the vault state is IDLE or REQ

invariant state_idle_req_global()
    currentContract.state == Vault.States.IDLE || currentContract.state == Vault.States.REQ;

