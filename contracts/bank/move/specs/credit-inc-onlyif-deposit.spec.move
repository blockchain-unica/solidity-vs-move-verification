// if the credit of a user A is increased after a transaction [of the Bank contract], then that transaction must be a deposit where A is the sender
// contrapositive: for every transaction that is not a deposit, or for which A is not the sender, then credit of A is not increased

spec bank_addr::bank {

    spec withdraw {    
        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;
        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value; 
        ensures bank_credits_sender_coin_value_post <= bank_credits_sender_coin_value;
    }

    spec deposit {
        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;

        ensures forall a:address where simple_map::spec_contains_key(bank_credits,a) && a != signer::address_of(sender): simple_map::spec_get(bank_credits_post, a).value <= simple_map::spec_get(bank_credits,a).value;
    }
}
