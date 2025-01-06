// after a successful deposit(amount), exactly amount units of T pass from the control of the sender to that of the contract.

spec bank_addr::bank {
    use std::features;

    spec deposit {
        let addr_sender = signer::address_of(sender);
        let sender_coins_value = global<coin::CoinStore<AptosCoin>>(addr_sender).coin.value;
        let post sender_coins_value_post = global<coin::CoinStore<AptosCoin>>(addr_sender).coin.value;

        let bank_credits = global<Bank>(bank).credits;
        let post bank_credits_post = global<Bank>(bank).credits;

	    let bank_credits_sender_coin_value =
	        if (simple_map::spec_contains_key(bank_credits, addr_sender))
	            { simple_map::spec_get(bank_credits,signer::address_of(sender)).value }
	        else
	        	{ 0 };
	    let post bank_credits_sender_coin_value_post =  simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value;
        
        // implies deposit-assets-credit
        ensures bank_credits_sender_coin_value_post == bank_credits_sender_coin_value + amount;

	    requires !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);
        ensures sender_coins_value_post == (sender_coins_value - amount);
    }
}
