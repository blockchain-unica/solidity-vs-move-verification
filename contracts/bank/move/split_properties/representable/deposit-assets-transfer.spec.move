spec bank_apt::bank {
    spec deposit {

        // deposit-assets-transfer: (if sender is not the contract) after a successful deposit(amount), exactly amount units of T pass from the control of the sender to that of the contract.
        // Representable
        // covering all aborts
        // represents the "after a successful deposit" property
        let sender_coins_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
        let post sender_coins_value_post = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;


        let bank_credits = global<Bank>(bank).credits;
        let post bank_credits_post = global<Bank>(bank).credits;
        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value;

        ensures (bank_credits_sender_coin_value_post == (bank_credits_sender_coin_value + amount)) && (sender_coins_value_post == (sender_coins_value - amount));
    }
}
