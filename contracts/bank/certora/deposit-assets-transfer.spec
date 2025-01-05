// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:deposit-assets-transfer.spec
// https://prover.certora.com/output/454304/6eefb88580c4466f8c6fe9e49b8d3291?anonymousKey=ab11ba260bf3e46b25562e8965b9af955e8b66f3

// after a successful deposit(amount), exactly amount units of T pass from the control of the sender to that of the contract.

rule deposit_assets_transfer {
    env e;

    require e.msg.sender != currentContract;

    mathint old_contract_balance = nativeBalances[currentContract];
    mathint old_sender_balance = nativeBalances[e.msg.sender];
    deposit(e);
    mathint new_contract_balance = nativeBalances[currentContract];

    assert new_contract_balance == old_contract_balance + e.msg.value;
    assert nativeBalances[e.msg.sender] == old_sender_balance - e.msg.value;
}
