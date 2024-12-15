spec bank_apt::bank {
    spec deposit {

        // deposit-not-revert: (up-to overflows) a transaction deposit(amount) does not abort if amount is less or equal to the T balance of the transaction sender.

        // Not Available in Move on Aptos: the "does not abort" is not representable
        // in Move Specification Language for now
    }
}
