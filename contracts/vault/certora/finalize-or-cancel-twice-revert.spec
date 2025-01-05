// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-or-cancel-twice-revert.spec
// https://prover.certora.com/output/454304/fe1088c7f5724d0ba775e7378382ae03?anonymousKey=2b4a4c3b7b64b1b8d0812c4fbdfdc86c197cf476

// a finalize() or cancel() transaction aborts if performed immediately after another finalize() or cancel()

rule finalize_or_cancel_twice_revert {
    env e1;
    bool b1;
    if (b1) {
        finalize(e1);
    } else {
        cancel(e1);
    }
    
    env e2;
    bool b2;
    if (b2) {
        finalize@withrevert(e2);
    } else {
        cancel@withrevert(e2);
    }
    
    assert lastReverted;
}
