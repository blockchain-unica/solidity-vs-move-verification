// if the credit of a user A is decreased after a transaction [of the Bank contract], then that transaction must be a withdraw where A is the sender
// contrapositive: for every transaction that is not a withdraw, or for which A is not the sender, then credit of A is not decreased

spec bank_addr::bank {
    spec deposit {
        let addr_sender = signer::address_of(sender);

        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;
        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value;
 
        requires simple_map::spec_contains_key(bank_credits, addr_sender);
        ensures bank_credits_sender_coin_value_post >= bank_credits_sender_coin_value;
    }

    spec withdraw {
        let addr_sender = signer::address_of(sender);

        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;

        ensures forall a: address where a!=addr_sender : simple_map::spec_get(bank_credits_post,a).value >= simple_map::spec_get(bank_credits,a).value;
    }
}
