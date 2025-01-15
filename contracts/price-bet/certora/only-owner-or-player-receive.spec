// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Pricebet.sol --verify Pricebet:only-owner-or-player-receive.spec
// https://prover.certora.com/output/454304/eec1caf4736146c089b583e84e53003a?anonymousKey=7ea2b42d4391e250c866d1c8d708b85001608db0

// in any state after join(), only the owner or the player can receive tokens from the contract

rule only_owner_or_player_receive {
    env e;
    method f;
    calldataarg args;

    // address of the user who will receive the tokens
    address a;

    // the player has joined
    require currentContract.player != 0;

    uint a_balance_before = nativeBalances[a];

    f(e, args);

    uint a_balance_after = nativeBalances[a];

    assert 
        a_balance_after>a_balance_before 
        => 
        a==currentContract.owner || a==currentContract.player;
}
