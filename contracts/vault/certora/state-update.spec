// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:state-update.spec
// https://prover.certora.com/output/454304/772a9f792ed440818577ee1563ba91a7?anonymousKey=bb2efdc2f0182a910856fc82fed2689f9fa65b13

// the contract implements a state machine with transitions:
// s -> s upon a receive (for any s)
// IDLE -> REQ upon a withdraw,
// REQ -> IDLE upon a finalize or a cancel

rule state_update {
    env e;
    method f;
    calldataarg args;

    Vault.States s0 = currentContract.state;
    f(e, args); 

    Vault.States s1 = currentContract.state;

    if (f.selector == sig:withdraw(address,uint).selector) 
        assert s0 == Vault.States.IDLE && s1 == Vault.States.REQ;
    else if (f.selector == sig:finalize().selector)
        assert s0 == Vault.States.REQ && s1 == Vault.States.IDLE;
    else if (f.selector == sig:cancel().selector)
        assert s0 == Vault.States.REQ && s1 == Vault.States.IDLE;
    else // receive
        assert s0 == s1;
}
