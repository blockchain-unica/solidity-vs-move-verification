// a transaction finalize() aborts if the sender is not the owner, or if the state is not REQ

spec vault_addr::vault {

   spec finalize {
      // the abort condition is an "if", not an "if and only if"
      pragma aborts_if_is_partial = true;

      let addr_owner = signer::address_of(owner);

      let vault = global<Vault<CoinType>>(addr_owner);

      aborts_if addr_owner != vault.owner || vault.state != REQ;
 }
}
