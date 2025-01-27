//  after a successful transaction, the credits of at least one user have changed [exists/forall]

spec bank_addr::bank {

   spec module {
     use std::features;
     // use aptos_framework::aptos_coin::{Self, AptosCoin};
         
     invariant update [global] forall owner: address where old(exists<Bank>(owner)): 
        (
      !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION) &&
           global<Bank>(owner) != old(global<Bank>(owner)) && exists<Bank>(owner)
      ==>
           (
           exists addr_a: address:
         (
         simple_map::spec_contains_key(global<Bank>(owner).credits,addr_a)
         &&
         (
            !old(simple_map::spec_contains_key(global<Bank>(owner).credits,addr_a)) // bart: questo serve
              ||
       (
        simple_map::spec_get(global<Bank>(owner).credits,addr_a).value !=
                 old(simple_map::spec_get(global<Bank>(owner).credits,addr_a).value)	 // bart: questo serve
       )
         )
              // global<coin::CoinStore<AptosCoin>>(addr_a).coin.value != old(global<coin::CoinStore<AptosCoin>>(addr_a).coin.value)
           )
     )
        );
   }
}
