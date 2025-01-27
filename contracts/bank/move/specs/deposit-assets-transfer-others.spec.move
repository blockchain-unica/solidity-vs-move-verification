// after a successful deposit(amount), the assets controlled by any user but the sender are preserved.

spec bank_addr::bank {
    spec deposit {
        let addr_sender = signer::address_of(sender);

        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;

        ensures forall a: address where a!=addr_sender : simple_map::spec_get(bank_credits_post,a).value == simple_map::spec_get(bank_credits,a).value;
        ensures forall a: address where a!=addr_sender : global<coin::CoinStore<AptosCoin>>(a).coin.value == old(global<coin::CoinStore<AptosCoin>>(a).coin.value);
    }
}