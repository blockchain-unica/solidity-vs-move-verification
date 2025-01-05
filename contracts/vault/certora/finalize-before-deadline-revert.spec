// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:finalize-before-deadline-revert.spec
// https://prover.certora.com/output/454304/efd075063c7341458fe43516f959f9a9?anonymousKey=797ae1ce2c3e765d354867da33fdb05ae7faecdf

// a finalize() transaction is aborted if sent before wait_time time units have elapsed after a successful withdraw()

rule finalize_before_deadline_revert {
    env e1;
    
    address addr;
    uint amt;
    withdraw(e1, addr, amt);

    env e2;
    // require (to_mathint(e2.block.number) < to_mathint(e1.block.number) + to_mathint(currentContract.wait_time));
    require e2.block.number < e1.block.number + currentContract.wait_time;

    finalize@withrevert(e2);

    assert lastReverted;
}
