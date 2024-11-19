spec bank_apt::bank {
    
    spec withdraw {
        aborts_if amount == 0;
        aborts_if !exists<Bank>(bank);
        aborts_if !exists<coin::CoinStore<AptosCoin>>(signer::address_of(from));
        aborts_if !global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).frozen;

        aborts_if !coin::spec_is_account_registered<coin::CoinInfo<AptosCoin>>(signer::address_of(from));

        modifies global<Bank>(bank);
        
        let bank_clients = global<Bank>(bank).clients;
        aborts_if !simple_map::spec_contains_key(bank_clients,signer::address_of(from));
        let post bank_clients_post = global<Bank>(bank).clients;
        let bank_clients_from_coin_value = simple_map::spec_get(bank_clients,signer::address_of(from)).value;
        let post bank_clients_from_coin_value_post =  simple_map::spec_get(bank_clients,signer::address_of(from)).value;
        aborts_if bank_clients_from_coin_value < amount;
        
        let from_coin_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).coin.value;
        let post from_coin_value_post =  global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).coin.value;

        // ensures forall a:address where simple_map::spec_contains_key(bank_clients,a) && a != signer::address_of(from): simple_map::spec_get(bank_clients_post, a) == simple_map::spec_get(bank_clients,a);
        // ensures false;
        ensures simple_map::spec_get(bank_clients_post,signer::address_of(from)) != 
            simple_map::spec_get(bank_clients, signer::address_of(from));
        // ensures bank_clients_from_coin_value_post == (bank_clients_from_coin_value - amount); // inside bank client account there is less money if i do a withdraw

        // ensures from_coin_value_post == (from_coin_value + amount);// inside the coinstore of an user there is more money

    }

    // spec deposit {
    //     // pragma intrinsic; // makes a difference when proving stuff 
    //     // apparently it does use implementation defined skipping the 
    //     // move implementation
    //     aborts_if amount >= 0;
    //     aborts_if !exists<Bank>(bank);
    //     let to_coin_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(to)).coin.value;
    //     let post to_coin_value_post =  global<coin::CoinStore<AptosCoin>>(signer::address_of(to)).coin.value;
    //     let bank_clients = global<Bank>(bank).clients;
    //     aborts_if !simple_map::spec_contains_key(bank_clients,signer::address_of(to));
    //     let client_to_coin = simple_map::spec_get(bank_clients,signer::address_of(to)).value;
    //     let post client_to_coin_post =  simple_map::spec_get(bank_clients,signer::address_of(to)).value;
    //     aborts_if client_to_coin < amount;
    //     ensures client_to_coin_post == (client_to_coin + amount); // inside bank client account there is more money if i do a deposit
    //     ensures to_coin_value_post == (to_coin_value - amount);// inside the coinstore of an user there is less money
    //
    // }


}
