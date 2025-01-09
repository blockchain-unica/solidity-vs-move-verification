// after a successful receive()  the state has not changed 
spec vault_addr::vault {
   //use std::features;

   spec receive {  
      // TODO change param name in method receive()? 
      let _vault = borrow_global_mut<Vault<CoinType>>(vault);
      let post _vault_post = borrow_global_mut<Vault<CoinType>>(vault);

      ensures _vault.state == _vault_post.state;
 }
}

