// after a successful receive()  the state has not changed 
spec vault_addr::vault {
   //use std::features;

   spec receive {  
      let vault = borrow_global_mut<Vault<CoinType>>(vault_addr);
      let post vault_post = borrow_global_mut<Vault<CoinType>>(vault_addr);

      ensures vault.state == vault_post.state;
 }
}

