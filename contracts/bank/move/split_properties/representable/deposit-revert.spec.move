spec bank_apt::bank {
    spec deposit {
        // deposit-revert: a transaction deposit(amount) aborts if amount is more than the T balance of the transaction sender
        // Representable

        let sender_coins_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
        aborts_if sender_coins_value < amount;
    }
}
