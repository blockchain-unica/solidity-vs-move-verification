// if the assets of a user A are increased after a transaction [of the Bank contract], then that transaction must be a withdraw where A is the sender
// contrapositive: for every transaction that is not a withdraw, or for which A is not the sender, then assets of A are not increased

spec bank_addr::bank {    
    spec deposit {
        let addr_sender = signer::address_of(sender);

        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;

        ensures forall a: address where a!=addr_sender : global<coin::CoinStore<AptosCoin>>(a).coin.value <= old(global<coin::CoinStore<AptosCoin>>(a).coin.value);
    }
    
    spec withdraw {
        let addr_sender = signer::address_of(sender);

        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;

        ensures forall a: address where a!=addr_sender : global<coin::CoinStore<AptosCoin>>(a).coin.value <= old(global<coin::CoinStore<AptosCoin>>(a).coin.value);
    }
}
