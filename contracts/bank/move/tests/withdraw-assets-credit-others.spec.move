// after a successful withdraw(amount), the credits of any user but the sender are preserved.

spec bank_addr::bank {
    spec withdraw {
        let bank_credits = global<Bank>(bank).credits;
        let post bank_credits_post = global<Bank>(bank).credits;

        ensures forall a:address where simple_map::spec_contains_key(bank_credits,a) && a != signer::address_of(sender): simple_map::spec_get(bank_credits_post, a).value == simple_map::spec_get(bank_credits,a).value;
    }
}