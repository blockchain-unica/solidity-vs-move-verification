spec bank_addr::bank {
     use std::features;
     
     spec deposit {
        // deposit-revert: a transaction deposit(amount) aborts if amount is more than the T balance of the transaction sender	

	pragma aborts_if_is_partial = true;
	
        let sender_coins_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;

	aborts_if sender_coins_value < amount && !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);
   }
}
