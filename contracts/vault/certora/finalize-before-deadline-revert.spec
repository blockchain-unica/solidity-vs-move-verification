// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-before-deadline-revert.spec
// https://prover.certora.com/output/454304/efd075063c7341458fe43516f959f9a9?anonymousKey=797ae1ce2c3e765d354867da33fdb05ae7faecdf

// a finalize() transaction called immediately after a successful withdraw() aborts if sent before wait_time units have elapsed since the withdraw()

rule finalize_before_deadline_revert {
    env e1;
    
    address addr;
    uint amt;
    withdraw(e1, addr, amt);

    env e2;
    require e2.block.number < e1.block.number + currentContract.wait_time;

    finalize@withrevert(e2);

    assert lastReverted;
}
