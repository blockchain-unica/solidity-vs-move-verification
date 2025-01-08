spec vault_addr::vault {

    spec schema Unchanged<CoinType> {
        owner: address;
        requires exists<Vault<CoinType>>(owner);
        let owner_key = global<Vault<CoinType>>(owner).owner;
        let recovery_key = global<Vault<CoinType>>(owner).recovery;
        ensures owner_key == old(owner_key);
        ensures recovery_key == old(recovery_key);
    }
    
    spec module {
        // Enforce Unchanged for all functions except the init function.
        apply Unchanged to * except init;
    }
}