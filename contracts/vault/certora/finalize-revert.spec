// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-revert.spec
// https://prover.certora.com/output/454304/96bc7ebd485d47f29fc1ce0857f5c873?anonymousKey=43ceebbb82085e0862cc1aec4224d2cf023c880c

// a transaction finalize() aborts if:
// 1) the sender is not the owner, or 
// 2) the state is not REQ

rule finalize_revert {
    env e;

    require 
        e.msg.sender != currentContract.owner || 
        currentContract.state != Vault.States.REQ;

    finalize@withrevert(e);
    assert lastReverted;
}
