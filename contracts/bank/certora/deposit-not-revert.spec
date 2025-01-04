// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:deposit-not-revert.spec
// https://prover.certora.com/output/454304/c8f746671bd142839abc640bb7bd24dc?anonymousKey=5a55558cff1354490349e34dcb8ada01a397f16d

// (up-to overflows) a transaction deposit(amount) does not abort if amount is less or equal to the T balance of the transaction sender

rule deposit_not_revert {
    env e;

    require(e.msg.value <= nativeBalances[e.msg.sender]);
    require(currentContract.credits[e.msg.sender] + e.msg.value < max_uint);

    // The following require does not affect verification outcome (not enough ETH?)
    // require(nativeBalances[currentContract] + e.msg.value < max_uint);

    deposit@withrevert(e);

    assert !lastReverted;
}

