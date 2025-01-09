// a successful cancel()  moves the vault state from REQ to IDLE

spec vault_addr::vault {
   //use std::features;

   spec cancel {  
      let vault = global<Vault<CoinType>>(owner);
      let post vault_post = borrow_global_mut<Vault<CoinType>>(owner);

      ensures vault.state == REQ && vault_post.state == IDLE;
 }
}

