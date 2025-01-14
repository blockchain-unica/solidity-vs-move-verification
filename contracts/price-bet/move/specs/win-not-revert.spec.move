//  a transaction win() does not revert if the deadline has not expired, the sender is the player, or the oracle exchange rate is greater or equal to the bet exchange rate.

spec pricebet_addr::pricebet {
	spec win {     
		requires exists<PriceBet<CoinType>>(owner);
        let price_bet = global<PriceBet<CoinType>>(owner);
        let exchange_rate = oracle::get_exchange_rate();

		requires exists<block::BlockResource>(@aptos_framework);
	
        requires price_bet.deadline_block < block::get_current_block_height();
        requires price_bet.player == signer::address_of(player);
        requires exchange_rate >= price_bet.exchange_rate;

		requires exists<coin::CoinStore<CoinType>>(price_bet.player);
		let coin_store = global<coin::CoinStore<CoinType>>(price_bet.player);
		requires !coin_store.frozen;
  
		aborts_if false;
   }
}
