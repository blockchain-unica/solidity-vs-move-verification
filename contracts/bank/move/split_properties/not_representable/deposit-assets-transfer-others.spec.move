spec bank_apt::bank {
    spec deposit {
// deposit-assets-transfer-others: after a successful deposit(amount), the assets controlled by any user but the sender are preserved.
        // Probably Representable
        // the "after a successful deposit" is represented by covering all possible abort condition 

        let bank_credits = global<Bank>(bank).credits;
        let post bank_credits_post = global<Bank>(bank).credits;

        ensures forall a:address where simple_map::spec_contains_key(bank_credits,a) && a != signer::address_of(sender): exists<coin::CoinInfo<AptosCoin>>( simple_map::spec_get(bank_credits_post, a));

    }
}

