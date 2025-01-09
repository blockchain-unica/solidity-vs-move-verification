//  a finalize() transaction does not abort if it is sent by the owner, in state REQ, and at least wait_time time units have elapsed after request_timestamp.

spec vault_addr::vault {

   spec Vault {
      invariant !(state == REQ) || (coin::value(coins) >= amount);
   }

   spec finalize {
      let addr_owner = signer::address_of(owner);


      requires exists<Vault<CoinType>>(addr_owner);

      let vault = global<Vault<CoinType>>(addr_owner);

      requires exists<coin::CoinStore<CoinType>>(vault.receiver);
      let coin_store = global<coin::CoinStore<CoinType>>(vault.receiver);
      requires !coin_store.frozen;

      requires exists<timestamp::CurrentTimeMicroseconds>(@aptos_framework);
      
      requires addr_owner == vault.owner; 
      requires vault.state == REQ;
      requires timestamp::now_seconds() >= vault.request_timestamp + vault.wait_time;

      // requires coin::value(vault.coins) >= vault.amount;
      aborts_if false;
 }
}
