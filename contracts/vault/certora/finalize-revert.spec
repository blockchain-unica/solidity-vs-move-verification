// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-revert.spec
// https://prover.certora.com/output/454304/adc88d56c60740b4ac5e584253bffcf0?anonymousKey=ee2f99a5049bd39c898a7e9a8b8c68c57faa26e5

// a transaction finalize() aborts if:
// 1) the sender is not the owner, or 
// 2) the state is not REQ, or
// 3) wait_time time units have not elapsed after request_timestamp

rule finalize_revert {
    env e;

    require 
        e.msg.sender != currentContract.owner || 
        currentContract.state != Vault.States.REQ ||
        e.block.number < currentContract.request_time + currentContract.wait_time;

    finalize@withrevert(e);
    assert lastReverted;
}
