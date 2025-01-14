// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:state-req-amount-consistent.spec
// https://prover.certora.com/output/454304/2174c653039445a8a230659be56efcbd?anonymousKey=771f6bb0fd44884e7d421a83191da644212a2111

// if the state is REQ, then the amount to be withdrawn is less or equal than the contract balance

invariant state_req_amount_consistent()
    currentContract.state==Vault.States.REQ => currentContract.amount <= nativeBalances[currentContract];

