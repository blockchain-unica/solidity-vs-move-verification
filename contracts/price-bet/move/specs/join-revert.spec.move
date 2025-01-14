// a transaction join() reverts if the amount sent is different from initial_pot or another player has already joined
spec pricebet_addr::pricebet {
    use std::features;
    
    spec join {
        // the abort condition is an "if", not an "if and only if"
        pragma aborts_if_is_partial = true;

        let price_bet = global<PriceBet<CoinType>>(owner);

        aborts_if bet != coin::value(price_bet.pot) || price_bet.player != @0x0;
  }
}