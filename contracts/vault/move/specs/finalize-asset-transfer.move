// after a successful finalize()), exactly amount units of T pass from the control of the contract to that of the sender.

spec vault_addr::vault {
    use std::features;

    spec finalize {
        let sender_coins_value = global<coin::CoinStore<Coin>>(signer::address_of(sender)).coin.value;
        let post sender_coins_value_post = global<coin::CoinStore<Coin>>(signer::address_of(sender)).coin.value;

        let vault_struct = global<Vault>(owner).vault;
        let amount = vault_struct.amount;
        
        requires !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);
	    ensures (sender_coins_value_post == (sender_coins_value + amount));
    }
}
