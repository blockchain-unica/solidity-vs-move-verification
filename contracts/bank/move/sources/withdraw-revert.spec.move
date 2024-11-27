spec bank_apt::bank {
    spec withdraw {
        let sender_coinstore_coin_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;
        aborts_if sender_coinstore_coin_value < amount || amount == 0;
    }
}
