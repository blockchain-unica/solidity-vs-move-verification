//  a transaction timeout() does not revert if the deadline has passed

spec pricebet_addr::pricebet {
	spec timeout {     

		requires exists<PriceBet<CoinType>>(owner);
        let price_bet = global<PriceBet<CoinType>>(owner);
        let exchange_rate = oracle::get_exchange_rate(price_bet.oracle);


		requires exists<timestamp::CurrentTimeMicroseconds>(@aptos_framework);
		requires timestamp::now_seconds() >= price_bet.deadline;
	
		//requires exists<block::BlockResource>(@aptos_framework);
        //requires price_bet.deadline_block >= block::get_current_block_height();
        
		requires exists<coin::CoinStore<CoinType>>(owner);	// TODO check with contract TODO line 53
		let coin_store = global<coin::CoinStore<CoinType>>(owner);
		requires !coin_store.frozen;
  
		aborts_if false;
   }
}
