// after a successful finalize(), exactly amount units of T pass from the control of the contract to that of the receiver.

spec vault_addr::vault {
    use std::features;

    spec finalize {
        let vault = global<Vault<CoinType>>(signer::address_of(owner));
        let post vault_post = global<Vault<CoinType>>(signer::address_of(owner));

        let receiver_coins_value = global<coin::CoinStore<CoinType>>(vault.receiver).coin.value;
        let post receiver_coins_value_post = global<coin::CoinStore<CoinType>>(vault.receiver).coin.value;

        let vault_coin_value = vault.coins.value;
        let post vault_coin_value_post = vault_post.coins.value;

        ensures (vault_coin_value_post == (vault_coin_value - vault.amount));

        requires !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);
	ensures (receiver_coins_value_post == (receiver_coins_value + vault.amount));
    }
}
