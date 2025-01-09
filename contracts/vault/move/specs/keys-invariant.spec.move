spec vault_addr::vault {

    spec schema Unchanged<CoinType> {
        owner : address;

        let vault = global<Vault<CoinType>>(owner);
        
        requires exists<Vault<CoinType>>(owner);
        let owner_key = global<Vault<CoinType>>(owner).owner;
        let recovery_key = global<Vault<CoinType>>(owner).recovery;

        let post owner_key_post = global<Vault<CoinType>>(owner).owner;
        let post recovery_key_post = global<Vault<CoinType>>(owner).recovery;

        ensures owner_key == owner_key_post;
        ensures recovery_key == recovery_key_post;
    }
    
    spec receive {
        include Unchanged<CoinType>{owner : signer::address_of(sender)};
    }
    spec withdraw {
        include Unchanged<CoinType>{owner : signer::address_of(owner)};
    }
    spec finalize {
        include Unchanged<CoinType>{owner : signer::address_of(owner)};
    }
    spec cancel {
        include Unchanged<CoinType>{owner : owner};
    }
}