spec bank_apt::bank {
    
    spec withdraw {
        aborts_if amount == 0;
        aborts_if !exists<Bank>(bank);
        aborts_if !exists<coin::CoinStore<AptosCoin>>(signer::address_of(sender));
        aborts_if !global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).frozen;

        aborts_if !coin::spec_is_account_registered<coin::CoinInfo<AptosCoin>>(signer::address_of(sender));

        modifies global<Bank>(bank);
        
        let bank_credits = global<Bank>(bank).credits;
        aborts_if !simple_map::spec_contains_key(bank_credits,signer::address_of(sender));
        let post bank_credits_post = global<Bank>(bank).credits;
        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        aborts_if bank_credits_sender_coin_value < amount;
        
        let sender_coin_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
        let post sender_coin_value_post =  global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;

        // ensures forall a:address where simple_map::spec_contains_key(bank_credits,a) && a != signer::address_of(sender): simple_map::spec_get(bank_credits_post, a) == simple_map::spec_get(bank_credits,a);
        // ensures false;
        ensures simple_map::spec_get(bank_credits_post,signer::address_of(sender)) != 
            simple_map::spec_get(bank_credits, signer::address_of(sender));
        // ensures bank_credits_sender_coin_value_post == (bank_credits_sender_coin_value - amount); // inside bank client account there is less money if i do a withdraw

        // ensures sender_coin_value_post == (sender_coin_value + amount);// inside the coinstore of an user there is more money

    }

    // spec deposit {
    //     // pragma intrinsic; // makes a difference when proving stuff 
    //     // apparently it does use implementation defined skipping the 
    //     // move implementation
    //     aborts_if amount >= 0;
    //     aborts_if !exists<Bank>(bank);
    //     let sender_coin_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
    //     let post sender_coin_value_post =  global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
    //     let bank_credits = global<Bank>(bank).credits;
    //     aborts_if !simple_map::spec_contains_key(bank_credits,signer::address_of(sender));
    //     let client_sender_coin = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
    //     let post client_sender_coin_post =  simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
    //     aborts_if client_sender_coin < amount;
    //     ensures client_sender_coin_post == (client_sender_coin + amount); // inside bank client account there is more money if i do a deposit
    //     ensures sender_coin_value_post == (sender_coin_value - amount);// inside the coinstore of an user there is less money
    //
    // }


}
