// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:withdraw-withdraw-revert.spec
// https://prover.certora.com/output/454304/426650a41fed42d4945cbb415b1b3b57?anonymousKey=b676642949bacd61422f3cfeab75d54159d49f5b

// a transaction withdraw() aborts if performed immediately after another withdraw()

rule withdraw_withdraw_revert {
    env e1;
    address addr1;
    uint amt1;
    withdraw(e1, addr1, amt1);
    
    env e2;
    address addr2;
    uint amt2;
    withdraw@withrevert(e2, addr2, amt2);
    
    assert lastReverted;
}
