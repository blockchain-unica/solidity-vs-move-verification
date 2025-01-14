// a transaction timeout() reverts if the deadline has not passed yet

spec pricebet_addr::pricebet {
    
    spec timeout {
        // the abort condition is an "if", not an "if and only if"
        pragma aborts_if_is_partial = true;

        let price_bet = global<PriceBet<CoinType>>(owner);
        let exchange_rate = oracle::get_exchange_rate();

        aborts_if 
          price_bet.deadline_block < block::get_current_block_height();
  }
}