// a transaction withdraw(amount) aborts if amount is more than the transaction sender's credit or operation limit.

spec bank_addr::bank {

    spec withdraw {
        pragma aborts_if_is_partial;

        let bank = global<Bank>(bank);

        let sender_credits = simple_map::spec_get(bank.credits,signer::address_of(sender)).value;

        aborts_if
		sender_credits < amount ||
		(signer::address_of(sender)!=bank.owner && amount > bank.opLimit);
    }
}
