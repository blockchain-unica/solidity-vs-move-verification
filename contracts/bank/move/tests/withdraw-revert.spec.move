spec bank_addr::bank {
    spec withdraw {
        // withdraw-revert: a transaction withdraw(amount) aborts if amount is more than the credit of the transaction sender.
	pragma aborts_if_is_partial;

        let bank_credits = global<Bank>(owner).credits;

        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        aborts_if bank_credits_sender_coin_value < amount;
    }
}
