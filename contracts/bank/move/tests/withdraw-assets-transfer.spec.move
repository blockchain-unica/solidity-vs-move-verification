spec bank_addr::bank {
    use std::features;

    spec withdraw {

    // withdraw-assets-transfer: after a successful withdraw(amount), exactly amount units of T pass from the control of the contract to that of the sender.
        // Representable
        // covering all aborts
        // represents the "after a successful deposit" property
        // Representable

        let sender_coins_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
        let post sender_coins_value_post = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;


        let bank_credits = global<Bank>(bank).credits;
        let post bank_credits_post = global<Bank>(bank).credits;
        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value;

        ensures (bank_credits_sender_coin_value_post == (bank_credits_sender_coin_value - amount));

        requires !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);
	    ensures (sender_coins_value_post == (sender_coins_value + amount));

    }
}
