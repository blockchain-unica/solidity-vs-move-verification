// after a successful deposit(amount), exactly amount units of T pass from the control of the sender to that of the contract.
// (implied by deposit-assets-transfer)

spec bank_addr::bank {
     spec deposit {
        let addr_sender = signer::address_of(sender);

        let bank_credits = global<Bank>(owner).credits;
        let post bank_credits_post = global<Bank>(owner).credits;

	    let bank_credits_sender_coin_value =
	        if (simple_map::spec_contains_key(bank_credits, addr_sender))
	            { simple_map::spec_get(bank_credits,signer::address_of(sender)).value }
	        else
		        { 0 };	
        let post bank_credits_sender_coin_value_post = simple_map::spec_get(bank_credits_post,signer::address_of(sender)).value;
 
        ensures bank_credits_sender_coin_value_post == bank_credits_sender_coin_value + amount;
    }
}
