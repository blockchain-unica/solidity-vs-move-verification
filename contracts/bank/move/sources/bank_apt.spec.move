spec bank_apt::bank {
    
    spec withdraw {
        pragma intrinsic; // makes a difference when proving stuff 
        // apparently it does use implementation defined skipping the 
        // move implementation
        aborts_if amount <= 0;
        aborts_if !exists<Bank>(bank);
        let from_coin_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).coin.value;
        let post from_coin_value_post =  global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).coin.value;
        let bank_clients = global<Bank>(bank).clients;
        aborts_if !simple_map::spec_contains_key(bank_clients,signer::address_of(from));
        let client_from_coin = simple_map::spec_get(bank_clients,signer::address_of(from)).value;
        let post client_from_coin_post =  simple_map::spec_get(bank_clients,signer::address_of(from)).value;
        aborts_if client_from_coin < amount;
        ensures client_from_coin_post == (client_from_coin - amount); // inside bank client account there is less money if i do a withdraw
        ensures from_coin_value_post == (from_coin_value + amount);// inside the coinstore of an user there is more money

    }

    spec deposit {
        pragma intrinsic; // makes a difference when proving stuff 
        // apparently it does use implementation defined skipping the 
        // move implementation
        aborts_if amount <= 0;
        aborts_if !exists<Bank>(bank);
        let to_coin_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(to)).coin.value;
        let post to_coin_value_post =  global<coin::CoinStore<AptosCoin>>(signer::address_of(to)).coin.value;
        let bank_clients = global<Bank>(bank).clients;
        aborts_if !simple_map::spec_contains_key(bank_clients,signer::address_of(to));
        let client_to_coin = simple_map::spec_get(bank_clients,signer::address_of(to)).value;
        let post client_to_coin_post =  simple_map::spec_get(bank_clients,signer::address_of(to)).value;
        aborts_if client_to_coin < amount;
        ensures client_to_coin_post == (client_to_coin + amount); // inside bank client account there is more money if i do a deposit
        ensures to_coin_value_post == (to_coin_value - amount);// inside the coinstore of an user there is less money

    }


}
