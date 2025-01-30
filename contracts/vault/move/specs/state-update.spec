// the contract implements a state machine with transitions:
// s -> s upon a receive (for any s)
// IDLE -> REQ upon a withdraw,
// REQ -> IDLE upon a finalize or a cancel.

spec vault_addr::vault {

  spec receive {  
    let vault = borrow_global_mut<Vault<CoinType>>(vault_addr);
    let post vault_post = borrow_global_mut<Vault<CoinType>>(vault_addr);

    ensures vault.state == vault_post.state;
  }

  spec withdraw {  
    let addr_owner = signer::address_of(owner);
    let vault = global<Vault<CoinType>>(addr_owner);
    let post vault_post = borrow_global_mut<Vault<CoinType>>(addr_owner);

    ensures vault.state == IDLE && vault_post.state == REQ;
  }

  spec finalize {  
    let addr_owner = signer::address_of(owner);
    let vault = global<Vault<CoinType>>(addr_owner);
    let post vault_post = borrow_global_mut<Vault<CoinType>>(addr_owner);

    ensures vault.state == REQ && vault_post.state == IDLE;
  }

  spec cancel {  
    let vault = global<Vault<CoinType>>(owner);
    let post vault_post = borrow_global_mut<Vault<CoinType>>(owner);

    ensures vault.state == REQ && vault_post.state == IDLE;
  }
}
