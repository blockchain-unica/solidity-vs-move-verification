// if the assets of a user A are increased after a transaction [of the Bank contract], then that transaction must be a withdraw where A is the sender
// contrapositive: for every transaction that is not a withdraw, or for which A is not the sender, then assets of A are not increased

spec bank_addr::bank {    
    spec deposit {
        let sender_coins_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
        let post sender_coins_value_post = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;

        requires !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);
        ensures sender_coins_value_post <= sender_coins_value;
    }
    
    spec withdraw {
        let addr_sender = signer::address_of(sender);

        ensures forall a: address where a!=addr_sender : global<coin::CoinStore<AptosCoin>>(a).coin.value <= old(global<coin::CoinStore<AptosCoin>>(a).coin.value);
    }
}
