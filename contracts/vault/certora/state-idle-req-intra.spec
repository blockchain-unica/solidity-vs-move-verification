// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:state-idle-req-intra.spec
// https://prover.certora.com/output/454304/eb6c0eb0c3714d71898381be33d0fdd6?anonymousKey=26b85202bdaf19486ebaea6a0efa61fac6339855

// during the execution of a transaction, the vault state is always IDLE or REQ

ghost bool state_idle_req { init_state axiom true; }

hook Sstore state Vault.States new_state (Vault.States old_state) {
    state_idle_req = new_state == Vault.States.IDLE || new_state == Vault.States.REQ;
}

invariant state_idle_req_local()
    state_idle_req;
