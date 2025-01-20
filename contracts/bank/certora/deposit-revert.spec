// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:deposit-revert.spec
// https://prover.certora.com/output/454304/639e2fba699549beb6e270040a05e0f7?anonymousKey=1d3ef2bc8767b156c300cf7785c3c2ee66bd8f16

// a transaction deposit(amount) aborts if amount is greater than 
// the transaction sender’s T balance or operation limit.  

rule deposit_revert {
    env e;

    require(
        e.msg.value > nativeBalances[e.msg.sender] ||
        (e.msg.sender!=currentContract.owner && e.msg.value > currentContract.opLimit));

    deposit@withrevert(e);
    
    assert lastReverted;
}
