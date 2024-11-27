spec bank_apt::bank {
    spec deposit {
        
        let credits = global<Bank>(bank).credits;
        let post credits_post = global<Bank>(bank).credits;
        ensures simple_map::spec_contains_key(credits,signer::address_of(sender)) 
            ==> (simple_map::spec_get(credits_post,signer::address_of(sender)).value == 
        simple_map::spec_get(credits,signer::address_of(sender)).value + amount);//(1,4)
        ensures !simple_map::spec_contains_key(credits,signer::address_of(sender)) 
            ==> (simple_map::spec_get(credits_post,signer::address_of(sender)).value == amount);//(1,4)

    }
}
