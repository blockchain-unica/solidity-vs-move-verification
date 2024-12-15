spec bank_apt::bank {
    spec withdraw {
// withdraw-revert: a transaction withdraw(amount) aborts if amount is more than the credit of the transaction sender.
// Representable
        let bank_credits = global<Bank>(bank).credits;

        let bank_credits_sender_coin_value = simple_map::spec_get(bank_credits,signer::address_of(sender)).value;
        aborts_if bank_credits_sender_coin_value < amount;
    }
}
