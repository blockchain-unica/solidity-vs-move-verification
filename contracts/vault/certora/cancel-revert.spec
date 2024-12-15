// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:cancel-revert.spec
// https://prover.certora.com/output/454304/4ed5572fd1d447bb96d21f1015b0b839?anonymousKey=127a591b0752e48b96b805a1f6db3e947e42877d

// a transaction cancel() aborts if the signer uses a key different from the recovery key

rule cancel_revert {
    env e;

    require e.msg.sender != currentContract.recovery;
    cancel@withrevert(e);
    assert lastReverted;
}
