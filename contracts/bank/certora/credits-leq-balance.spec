// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank.sol:Bank --verify Bank:credits-leq-balance.spec

// the assets controlled by the contract are (at least) equal to the sum of all the credits

ghost mathint sum_credits { init_state axiom sum_credits==0; }

hook Sstore credits[KEY address a] uint new_value (uint old_value) {
    if (a!=currentContract) {
        sum_credits = sum_credits - old_value + new_value;
    }
}

invariant credits_leq_balance()
    nativeBalances[currentContract] >= sum_credits;