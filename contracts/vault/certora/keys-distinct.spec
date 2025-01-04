// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Vault.sol --verify Vault:keys-distinct.spec
// https://prover.certora.com/output/454304/732c5e6386ba4aea9ae053fd53e9c2c1?anonymousKey=d9cb0e380189b23b5a3b16737e3ec268db1d0c8d

// the owner key and the recovery key are distinct.

invariant keys_distinct()
    currentContract.owner != currentContract.recovery;