// the owner key and the recovery key are distinct.

spec vault_addr::vault {
  spec Vault {
     invariant !(owner == recovery);
}
}
