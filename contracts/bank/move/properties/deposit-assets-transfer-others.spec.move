spec bank_addr::bank {
    spec deposit {
        // deposit-assets-transfer-others: after a successful deposit(amount), the assets controlled by any user but the sender are preserved.

        let addr_sender = signer::address_of(sender);
        // let sender_coins_value = global<coin::CoinStore<AptosCoin>>(addr_sender).coin.value;
        // let post sender_coins_value_post = global<coin::CoinStore<AptosCoin>>(addr_sender).coin.value;

        let bank_credits = global<Bank>(bank).credits;
        let post bank_credits_post = global<Bank>(bank).credits;
        // let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        // let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value;

        ensures forall a: address where a!=addr_sender : simple_map::spec_get(bank_credits_post,a).value == simple_map::spec_get(bank_credits,a).value;
        ensures forall a: address where a!=addr_sender : global<coin::CoinStore<AptosCoin>>(a).coin.value == old(global<coin::CoinStore<AptosCoin>>(a).coin.value);
    }
}