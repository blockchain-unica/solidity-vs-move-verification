// (up-to overflows) a transaction deposit(amount) does not abort if amount is less or equal to the T balance of the transaction sender.

spec bank_addr::bank {
     use std::features;

     spec deposit {
       	let addr_sender = signer::address_of(sender);
  		let sender_balance = global<coin::CoinStore<AptosCoin>>(addr_sender).coin.value;
  		// requires !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);
  
  		// let bank_credits = global<Bank>(bank).credits;
    	// let sender_credits = simple_map::spec_get(bank_credits,addr_sender).value;
  		requires amount > 0;
    	requires amount <= sender_balance;
  		//requires amount < MAX_U64 - sender_credits;
  		requires amount == 1 && sender_balance == 2;
  		aborts_if false; // can never abort
    }
}