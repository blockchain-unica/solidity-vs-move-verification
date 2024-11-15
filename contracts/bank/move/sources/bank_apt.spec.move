spec bank_apt::bank {
    
    spec deposit {
        aborts_if !exists<Bank>(bank);
        
        modifies global<Bank>(bank); 
        
        let client_owned_coin = global<coin::CoinStore<Coin<AptosCoin>>>(signer::address_of(to)).coin.value;
        let post client_owned_coin_post = global<coin::CoinStore<Coin<AptosCoin>>>(signer::address_of(to)).coin.value;
        aborts_if client_owned_coin < amount ; //(3)
        ensures client_owned_coin_post == (client_owned_coin - amount);  
        // ensures sum_of_deposit == old(sum_of_deposit) + amount;
        let clients = global<Bank>(bank).clients;
        let post clients_post = global<Bank>(bank).clients;
        ensures simple_map::spec_contains_key(clients,signer::address_of(to)) 
            ==> (simple_map::spec_get(clients_post,signer::address_of(to)).value == 
            simple_map::spec_get(clients,signer::address_of(to)).value + amount);//(1,4)
        ensures !simple_map::spec_contains_key(clients,signer::address_of(to)) 
            ==> (simple_map::spec_get(clients_post,signer::address_of(to)).value == amount);//(1,4)
        ensures forall c: address where c != signer::address_of(to) && simple_map::spec_contains_key(clients,c):
            simple_map::spec_get(clients_post,c).value == simple_map::spec_get(clients,c).value; // no other client account is modified 

    }

    spec withdraw {
        aborts_if amount == 0; // (9, partially)
        
        modifies global<Bank>(bank); 

        aborts_if !exists<Bank>(bank);
        // aborts_if !exists<coin::CoinInfo<coin::CoinStore<AptosCoin>>>(signer::address_of(from));
        // aborts_if !coin::spec_is_account_registered<coin::CoinStore<AptosCoin>>(signer::address_of(from));
        aborts_if !coin::is_coin_initialized<coin::CoinStore<AptosCoin>>();
        // aborts_if global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).frozen;

        let clients = global<Bank>(bank).clients;
        let post clients_post = global<Bank>(bank).clients;
        aborts_if !simple_map::spec_contains_key(clients, signer::address_of(from));
        let client_bank_money = simple_map::spec_get(clients,signer::address_of(from)).value;
        // ensures sum_of_withdraw == old(sum_of_withdraw) + amount; 

        let post client_bank_money_post =  simple_map::spec_get(clients,signer::address_of(from)).value;
        // aborts_if !coin::spec_is_account_registered<coin::CoinStore<AptosCoin>>(signer::address_of(from));
        aborts_if client_bank_money < amount; // (9) 
        aborts_if global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).coin.value + amount > MAX_U64 ;// (9)
        ensures global<coin::CoinStore<AptosCoin>>(signer::address_of(from)).coin.value == (old(global<coin::CoinStore<AptosCoin>>(signer::address_of(from))).coin.value + amount); // (10)
        ensures client_bank_money_post == (client_bank_money - amount); // (12) 

        ensures forall c: address where c != signer::address_of(from) && simple_map::spec_contains_key(clients,c):
            simple_map::spec_get(clients_post,c).value == simple_map::spec_get(clients,c).value; 
        }
}
