// a transaction withdraw(amount) aborts if: 
// 1) amount is more than the contract balance, or 
// 2) if the sender is not the owner, or 
// 3) if the state is not IDLE.

spec vault_addr::vault {

   spec withdraw {
      // the abort condition is an "if", not an "if and only if"
      pragma aborts_if_is_partial = true;

      let addr_owner = signer::address_of(owner);

      let vault = global<Vault<CoinType>>(addr_owner);

      aborts_if 
         amount > vault.coins.value ||
         vault.state != IDLE;
 }
}
