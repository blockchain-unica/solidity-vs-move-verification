// a transaction withdraw(amount) does not abort if amount is less or equal to the credit of the transaction sender.

spec bank_addr::bank {

    use aptos_framework::aptos_account;
     
    spec withdraw {
        let addr_sender = signer::address_of(sender);
	
     	requires exists<coin::CoinStore<AptosCoin>>(addr_sender);
	let coin_store = global<coin::CoinStore<AptosCoin>>(addr_sender);
	requires !coin_store.frozen;

		//let sender_balance = global<coin::CoinStore<AptosCoin>>(addr_sender).coin.value;

	  	requires global<aptos_account::DirectTransferConfig>(addr_sender).allow_arbitrary_coin_transfers;

	  	//requires can_receive_paired_fungible_asset(addr_sender);
	  	requires exists<Bank>( bank );

	  	let bank_credits = global<Bank>(bank).credits;

	  	requires simple_map::spec_contains_key(bank_credits, addr_sender);
	  
	  	let sender_credits = simple_map::spec_get(bank_credits,addr_sender).value;

	  	requires sender_credits > 0;
	  	requires amount > 0;
     	requires amount <= sender_credits;
	  	//requires amount < MAX_U64 - sender_credits;

		aborts_if false; // can never abort
    }
}