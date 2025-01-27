// a transaction deposit(amount) aborts if amount is greater than the transaction sender's T balance or operation limit. 

spec bank_addr::bank {
     use std::features;
     
     spec deposit {
        // the abort condition is an "if", not an "if and only if"
	pragma aborts_if_is_partial = true;
	
        let sender_coins_value = global<coin::CoinStore<AptosCoin>>(signer::address_of(sender)).coin.value;

	let bank = global<Bank>(owner);
	
	aborts_if
		(sender_coins_value < amount && !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION)) ||
		(signer::address_of(sender)!=owner && amount > bank.opLimit);
   }
}