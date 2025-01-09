// a successful withdraw()  moves the vault state from IDLE to REQ

spec vault_addr::vault {
   //use std::features;

   spec withdraw {  

      let addr_owner = signer::address_of(owner);
      let vault = global<Vault<CoinType>>(addr_owner);
      let post vault_post = borrow_global_mut<Vault<CoinType>>(addr_owner);

      ensures vault.state == IDLE && vault_post.state == REQ;
 }
}

