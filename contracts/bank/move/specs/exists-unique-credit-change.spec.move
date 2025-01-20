//  after a successful transaction, the credits of exactly one user have changed [exists/forall]

spec bank_addr::bank {

   spec module {
     use std::features;
     // use aptos_framework::aptos_coin::{Self, AptosCoin};
         
     invariant update [global] forall bank: address where old(exists<Bank>(bank)): 
        (
      !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION) &&
           global<Bank>(bank) != old(global<Bank>(bank)) && exists<Bank>(bank)
      ==>
           (
           exists addr_a: address:
         (
         // global<Bank>(bank).owner == old(global<Bank>(bank).owner)
         simple_map::spec_contains_key(global<Bank>(bank).credits,addr_a)
         &&
         (
            !old(simple_map::spec_contains_key(global<Bank>(bank).credits,addr_a)) // bart: questo serve
              ||
       (
        simple_map::spec_get(global<Bank>(bank).credits,addr_a).value !=
                 old(simple_map::spec_get(global<Bank>(bank).credits,addr_a).value)	 // bart: questo serve
       )
         )
         &&
         (
            forall addr_b: address where addr_b != addr_a:
            (
               (
               !old(simple_map::spec_contains_key(global<Bank>(bank).credits,addr_b))
               && !simple_map::spec_contains_key(global<Bank>(bank).credits,addr_b)
               )
            ||
               (
               simple_map::spec_get(global<Bank>(bank).credits,addr_b).value 
               ==
               old(simple_map::spec_get(global<Bank>(bank).credits,addr_b).value)
               )
            )
         )
              // global<coin::CoinStore<AptosCoin>>(addr_a).coin.value != old(global<coin::CoinStore<AptosCoin>>(addr_a).coin.value)
           )
     )
        );
   }
}

// in the antecedent of implication?
           /*
           !(exists addr_a: address : 
              exists addr_b: address where addr_a != addr_b: 
              old(simple_map::spec_contains_key(global<Bank>(bank).credits, addr_a))
              &&
              old(simple_map::spec_contains_key(global<Bank>(bank).credits, addr_b))
           )
           ||
           */
