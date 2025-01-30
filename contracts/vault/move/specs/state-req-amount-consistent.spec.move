// if the state is REQ, then amount is less or equal than the contract balance

spec vault_addr::vault {
   spec Vault {
      invariant !(state == REQ) || (coin::value(coins) >= amount);
 }
 }
 