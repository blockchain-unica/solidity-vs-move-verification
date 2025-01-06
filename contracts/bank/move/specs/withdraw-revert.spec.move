// a transaction withdraw(amount) aborts if amount is more than the credit of the transaction sender.

spec bank_addr::bank {

    spec withdraw {
	    pragma aborts_if_is_partial;

        let bank_credits = global<Bank>(bank).credits;
        let sender_credits = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;

        aborts_if sender_credits < amount;
    }
}
