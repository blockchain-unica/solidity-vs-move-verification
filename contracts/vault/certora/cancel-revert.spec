// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:cancel-revert.spec
// https://prover.certora.com/output/454304/1853db43df8545c9abe9ec5186106326?anonymousKey=4f66d7bf719a01cb2e61536d24f334c6436ac38e

// a transaction cancel() aborts if: 
// 1) the signer uses a key different from the recovery key, or
// 2) the state is not REQ.

rule cancel_revert {
    env e;

    require 
        e.msg.sender != currentContract.recovery ||
        currentContract.state != Vault.States.REQ;

    cancel@withrevert(e);
    assert lastReverted;
}
