// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:keys-invariant.spec
// https://prover.certora.com/output/454304/13bc4b0a51e84e2d81d23d20e11cf244?anonymousKey=fe7870a9b3cf9b65e896faf6972203a4eb89b480
// verification fails because of the HAVOC in external call in finalize()

ghost bool owner_changed { init_state axiom !owner_changed; }

hook Sstore owner address new_addr (address old_addr) {
    if (new_addr != old_addr) owner_changed = true;
}

rule owner_invariant {
    env e;
    method f;
    calldataarg args;

    require !owner_changed;
    
    f(e, args); 
    
    assert !owner_changed;
}
