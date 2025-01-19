// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol --verify Bank:withdraw-revert.spec
// https://prover.certora.com/output/454304/a5ca5bd68e1f4e57b9f161dc52684911?anonymousKey=4b0e5858e925784a0eee2acff40b3cf094fbdc50

// a transaction withdraw(amount) aborts if amount is greater than 
// the transaction sender’s credit or operation limit.

rule withdraw_revert {
    env e;
    uint amount;

    require( 
        amount == 0 || 
        amount > currentContract.credits[e.msg.sender] ||
        (e.msg.sender!=currentContract.owner && amount > currentContract.opLimit));

    withdraw@withrevert(e, amount);

    assert lastReverted;
}
