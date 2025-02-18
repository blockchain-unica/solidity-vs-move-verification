// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:keys-invariant-intra.spec
// https://prover.certora.com/output/454304/d371c023fe6d49478c5fceaa57ef318f?anonymousKey=0c3de237f195b19ceb869d6c659162ff9f389636

// during the execution of a transaction, the owner key and the recovery key cannot be changed after the contract is deployed

ghost bool owner_unchanged { init_state axiom owner_unchanged; }
ghost bool recovery_unchanged { init_state axiom recovery_unchanged; }

hook Sstore owner address new_addr (address old_addr) {
    if (old_addr != 0 && new_addr != old_addr) owner_unchanged = false;
}

hook Sstore recovery address new_addr (address old_addr) {
    if (old_addr != 0 && new_addr != old_addr) recovery_unchanged = false;
}

invariant keys_invariant_local()
    owner_unchanged && recovery_unchanged;
