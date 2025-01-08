// a transaction cancel() aborts if the signer uses a key different from the recovery key, or the state is not REQ.
spec vault_addr::vault {

   spec cancel {
      // the abort condition is an "if", not an "if and only if"
      pragma aborts_if_is_partial = true;

      let addr_recovery = signer::address_of(recovery);

      let vault = global<Vault<CoinType>>(owner);

      aborts_if addr_recovery != vault.recovery || vault.state != REQ;
 }
}
