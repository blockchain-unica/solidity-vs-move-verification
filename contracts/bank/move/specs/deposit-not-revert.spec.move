//  (up-to overflows) a transaction deposit(amount) does not abort if amount is less than or equal to the transaction sender's T balance and operation limit.

spec bank_addr::bank {
     spec deposit {
     	  requires amount > 0;

     	  let addr_sender = signer::address_of(sender);
	  requires exists<Bank>(owner);
	  let bank_struct = global<Bank>(owner);

	  requires exists<coin::CoinStore<AptosCoin>>(addr_sender);
	  requires exists<coin::CoinStore<AptosCoin>>(addr_sender);
	  let coin_store = global<coin::CoinStore<AptosCoin>>(addr_sender);

	  // https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/coin.move:1071
	  requires !coin_store.frozen;

	  let sender_balance = coin_store.coin.value;
	  requires amount <= sender_balance;
	  
	  // requires simple_map::spec_contains_key(bank_struct.credits, addr_sender);
 	  // let sender_credits = simple_map::spec_get(bank_struct.credits, addr_sender).value;
 	  // requires amount <= MAX_U64 - sender_credits;

	  requires signer::address_of(sender)!=owner ==> amount <= bank_struct.opLimit;

 	  aborts_if false; // can never abort
    }
}