//  (in any blockchain state) the vault state is IDLE or REQ

spec vault_addr::vault {
   spec Vault {
      invariant (state == IDLE) || (state == REQ);
 }
 }
 