// the owner key and the recovery key are distinct.

spec vault_addr::vault {

  spec init {
       ensures signer::address_of(owner) != recovery;
  }
  
  spec receive {
    let vault_pre = borrow_global_mut<Vault<CoinType>>(vault_addr);
    requires vault_addr != vault_pre.recovery;
    
    let post vault_post = borrow_global_mut<Vault<CoinType>>(vault_addr);
    ensures vault_addr != vault_post.recovery;
  }

  spec withdraw {
    let owner_addr = signer::address_of(owner);
    let vault_pre = borrow_global_mut<Vault<CoinType>>(owner_addr);
    requires owner_addr != vault_pre.recovery;
    
    let post vault_post = borrow_global_mut<Vault<CoinType>>(owner_addr);
    ensures owner_addr != vault_post.recovery;
  }

  spec finalize {
    let owner_addr = signer::address_of(owner);
    let vault_pre = borrow_global_mut<Vault<CoinType>>(owner_addr);
    requires owner_addr != vault_pre.recovery;
    
    let post vault_post = borrow_global_mut<Vault<CoinType>>(owner_addr);
    ensures owner_addr != vault_post.recovery;
  }

  spec cancel {
    let vault_pre = borrow_global_mut<Vault<CoinType>>(owner);
    requires owner != vault_pre.recovery;
    
    let post vault_post = borrow_global_mut<Vault<CoinType>>(owner);
    ensures owner != vault_post.recovery;
  }

}

// Note that the following spec does not work, because owner is not recorded in the struct
// spec vault_addr::vault {
//   spec Vault {
//      invariant !(owner == recovery);
// }

