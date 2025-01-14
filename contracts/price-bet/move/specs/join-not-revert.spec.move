//  a transaction join() does not revert if the amount sent is equal to initial_pot and no player has joined yet

spec pricebet_addr::pricebet {
	spec join {     
		requires exists<PriceBet<CoinType>>(owner);
        let price_bet = global<PriceBet<CoinType>>(owner);
		requires bet == coin::value(price_bet.pot);
		requires price_bet.player == @0x0;

		let addr_player = signer::address_of(player);
		requires exists<coin::CoinStore<CoinType>>(addr_player);
		let coin_store = global<coin::CoinStore<CoinType>>(addr_player);
		// https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/coin.move:1071
		requires !coin_store.frozen;
		let player_balance = coin_store.coin.value;
		requires bet <= player_balance;

		aborts_if false;
   }
}
