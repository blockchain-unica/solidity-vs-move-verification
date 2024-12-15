// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:receive-not-revert.spec
// https://prover.certora.com/output/454304/13857ea2cb034145b7db8863343a6f82?anonymousKey=f4d8be418b769b89aff42908e2f0ec73bb95b4fc

// it is always possible to send assets to the contract

rule receive_not_revert {
    env e;
    method f;
    calldataarg args;

    require f.isFallback;
    require e.msg.sender != currentContract;
    require e.msg.value > 0;

    mathint old_contract_balance = nativeBalances[currentContract];
    f(e, args);
    assert nativeBalances[currentContract] > old_contract_balance;
}
