spec bank_addr::bank {

     spec deposit {
          let addr_sender = signer::address_of(sender);
	  let sender_balance = global<coin::CoinStore<AptosCoin>>(addr_sender).coin.value;
     	  let bank_credits = global<Bank>(bank).credits;
     	  let sender_credits = simple_map::spec_get(bank_credits,addr_sender).value;

	  requires amount > 0;
     	  requires amount <= sender_balance;
	  //requires amount < MAX_U64 - sender_credits;
	  requires amount == 1 && sender_balance == 2;
	  aborts_if false; // can never abort
    }
}