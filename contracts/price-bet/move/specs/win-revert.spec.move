//a transaction win() reverts if the deadline has expired or the sender is not the player or the oracle exchange rate is smaller than the bet exchange rate.
spec pricebet_addr::pricebet {
    use std::features;
    
    spec win {
        // the abort condition is an "if", not an "if and only if"
        pragma aborts_if_is_partial = true;

        let price_bet = global<PriceBet<CoinType>>(owner);
        let exchange_rate = oracle::get_exchange_rate();

        aborts_if 
          price_bet.deadline_block >= block::get_current_block_height() ||
          price_bet.player != signer::address_of(player) ||
          exchange_rate < price_bet.exchange_rate;
  }
}