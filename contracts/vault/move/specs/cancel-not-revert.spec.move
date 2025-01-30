// a transaction cancel() does not abort if the signer uses the recovery key, and the state is REQ.
spec vault_addr::vault {

   spec cancel {
      
      let addr_recovery = signer::address_of(recovery);

      let vault = global<Vault<CoinType>>(owner);

      requires exists<Vault<CoinType>>(owner);

      requires addr_recovery == vault.recovery;
      requires vault.state == REQ;

      aborts_if false;
 }
}
