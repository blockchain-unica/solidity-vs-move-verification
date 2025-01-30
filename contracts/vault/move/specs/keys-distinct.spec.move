// the owner key and the recovery key are distinct.

spec vault_addr::vault {

  spec module { 

      use aptos_framework::aptos_coin::{AptosCoin};
 
      invariant forall a : address where exists<Vault<AptosCoin>>(a):
      		global<Vault<AptosCoin>>(a).recovery != a;

      // the transition invariant below is not strictly needed,
      // but it is interesting to note that it cannot be verified
      // without the help of the global state invariant above
      
      invariant update forall a : address where old(exists<Vault<AptosCoin>>(a)):
      		global<Vault<AptosCoin>>(a).recovery != a;
  }
}
