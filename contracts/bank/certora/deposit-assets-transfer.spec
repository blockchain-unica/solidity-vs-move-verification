// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:deposit-assets-transfer.spec
// https://prover.certora.com/output/454304/7d2cb46a974c489ca7f2db7cd9d9c27c?anonymousKey=907108aeece2367b5a3d440b74f5c25400ab49da

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
