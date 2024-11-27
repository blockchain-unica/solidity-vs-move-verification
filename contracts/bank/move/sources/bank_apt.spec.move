spec bank_apt::bank {
    
    spec deposit {
        aborts_if !exists<Bank>(bank);
        
        modifies global<Bank>(bank); 
        
        let client_owned_coin = global<coin::CoinStore<Coin<AptosCoin>>>(signer::address_of(sender)).coin.value;
        let post client_owned_coin_post = global<coin::CoinStore<Coin<AptosCoin>>>(signer::address_of(sender)).coin.value;
        aborts_if client_owned_coin < amount ; //(3)
        ensures client_owned_coin_post == (client_owned_coin - amount);  
        // ensures sum_of_deposit == old(sum_of_deposit) + amount;
        let credits = global<Bank>(bank).credits;
        let post credits_post = global<Bank>(bank).credits;
        ensures simple_map::spec_contains_key(credits,signer::address_of(sender)) 
            ==> (simple_map::spec_get(credits_post,signer::address_of(sender)).value == 
            simple_map::spec_get(credits,signer::address_of(sender)).value + amount);//(1,4)
        ensures !simple_map::spec_contains_key(credits,signer::address_of(sender)) 
            ==> (simple_map::spec_get(credits_post,signer::address_of(sender)).value == amount);//(1,4)
        ensures forall c: address where c != signer::address_of(sender) && simple_map::spec_contains_key(credits,c):
            simple_map::spec_get(credits_post,c).value == simple_map::spec_get(credits,c).value; // no other client account is modified 

    }

    spec withdraw {
        aborts_if amount == 0; // (9, partially)
        
        modifies global<Bank>(bank); 

        aborts_if !exists<Bank>(bank);
        // aborts_if !exists<coin::CoinInfo<coin::CoinStore<AptosCoin>>>(signer::address_of(sender));
        // aborts_if !coin::spec_is_account_registered<coin::CoinStore<AptosCoin>>(signer::address_of(sender));
        aborts_if !coin::is_coin_initialized<coin::CoinStore<AptosCoin>>();
        // aborts_if global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).frozen;

        let credits = global<Bank>(bank).credits;
        let post credits_post = global<Bank>(bank).credits;
        aborts_if !simple_map::spec_contains_key(credits, signer::address_of(sender));
        let client_bank_money = simple_map::spec_get(credits,signer::address_of(sender)).value;
        // ensures sum_of_withdraw == old(sum_of_withdraw) + amount; 

        let post client_bank_money_post =  simple_map::spec_get(credits,signer::address_of(sender)).value;
        // aborts_if !coin::spec_is_account_registered<coin::CoinStore<AptosCoin>>(signer::address_of(sender));
        aborts_if client_bank_money < amount; // (9) 
        aborts_if global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value + amount > MAX_U64 ;// (9)
        ensures global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value == (old(global<coin::CoinStore<AptosCoin>>(signer::address_of(sender))).coin.value + amount); // (10)
        ensures client_bank_money_post == (client_bank_money - amount); // (12) 

        ensures forall c: address where c != signer::address_of(sender) && simple_map::spec_contains_key(credits,c):
            simple_map::spec_get(credits_post,c).value == simple_map::spec_get(credits,c).value; 
        }
}
