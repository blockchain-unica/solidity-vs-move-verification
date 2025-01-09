// a successful finalize()  moves the vault state from REQ to IDLE

spec vault_addr::vault {
   //use std::features;

   spec finalize {  

      let addr_owner = signer::address_of(owner);
      let vault = global<Vault<CoinType>>(addr_owner);
      let post vault_post = borrow_global_mut<Vault<CoinType>>(addr_owner);

      ensures vault.state == REQ && vault_post.state == IDLE;
 }
}

