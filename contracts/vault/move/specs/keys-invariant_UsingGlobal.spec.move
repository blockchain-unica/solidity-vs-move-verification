spec vault_addr::vault {
  spec module {
     use aptos_framework::aptos_coin::{Self, AptosCoin};
      
      invariant update forall a: address where old(exists<Vault<AptosCoin>>(a) ): 
         global<Vault<AptosCoin>>(a).recovery == old(global<Vault<AptosCoin>>(a).recovery);
 }
 }
