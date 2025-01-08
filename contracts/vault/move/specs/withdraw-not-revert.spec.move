//  a transaction withdraw(amount) does not abort if amount is less than or equal to the contract balance, if the sender is the owner, and the state is IDLE.

spec vault_addr::vault {
   spec withdraw {
      requires exists<timestamp::CurrentTimeMicroseconds>(@aptos_framework);

	   let addr_owner = signer::address_of(owner);

      let vault = global<Vault<CoinType>>(addr_owner);
      requires exists<Vault<CoinType>>(addr_owner);

      requires amount <= vault.coins.value;
      requires addr_owner == vault.owner;
      requires vault.state == IDLE;

      aborts_if false;

 }
}

