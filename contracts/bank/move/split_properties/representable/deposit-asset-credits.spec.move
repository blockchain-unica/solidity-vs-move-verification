spec bank_apt::bank {


    spec deposit {
       
    // deposit-assets-credit: after a successful deposit(amount), the users credit is increased by exactly amount units of T.
    // Representable: "after a successful deposit" happens when all abort condition are covered
        let bank_credits = global<Bank>(bank).credits;
        let post bank_credits_post = global<Bank>(bank).credits;
        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value; 

        ensures (bank_credits_sender_coin_value_post == (bank_credits_sender_coin_value + amount));
    }
}
