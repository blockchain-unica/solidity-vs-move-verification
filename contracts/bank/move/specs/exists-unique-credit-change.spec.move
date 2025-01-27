//  after a successful transaction, the credits of exactly one user have changed [exists/forall]

spec bank_addr::bank {

   spec module {
     use std::features;
         
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
         &&
         (
            forall addr_b: address where addr_b != addr_a:
            (
               (
               !old(simple_map::spec_contains_key(global<Bank>(owner).credits,addr_b))
               && !simple_map::spec_contains_key(global<Bank>(owner).credits,addr_b)
               )
            ||
               (
               simple_map::spec_get(global<Bank>(owner).credits,addr_b).value 
               ==
               old(simple_map::spec_get(global<Bank>(owner).credits,addr_b).value)
               )
            )
         )
              // global<coin::CoinStore<AptosCoin>>(addr_a).coin.value != old(global<coin::CoinStore<AptosCoin>>(addr_a).coin.value)
           )
     )
        );
   }
}
