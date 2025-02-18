// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:keys-invariant-inter.spec
// https://prover.certora.com/output/454304/212f0efe0ad1457a9db9531220c1ba71?anonymousKey=523a3f8ecc093d18a16fe56946ecf957eee3d627

// (in any blockchain state) the owner key and the recovery key cannot be changed after the contract is deployed

rule keys_invariant_global {
    env e;
    method f;
    calldataarg args;

    address old_owner = currentContract.owner;
    address old_recovery = currentContract.recovery;
  
    f(e, args); 
    
    assert currentContract.owner == old_owner && currentContract.recovery == old_recovery;
}
