// after a successful withdraw(amount), the users credit is decreased by exactly amount units of T.

spec bank_addr::bank {

    spec withdraw {
        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;
        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value; 

        ensures (bank_credits_sender_coin_value_post == (bank_credits_sender_coin_value - amount));
    }
}
