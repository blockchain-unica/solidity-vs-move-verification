// anyone can always send tokens to the contract.
spec vault_addr::vault {
   //use std::features;

   spec receive {     
      requires exists<Vault<CoinType>>(vault);

      let addr_sender = signer::address_of(owner);
      requires exists<coin::CoinStore<CoinType>>(addr_sender);
      let coin_store = global<coin::CoinStore<CoinType>>(addr_sender);

      // https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/aptos-framework/sources/coin.move:1071
      requires !coin_store.frozen;
 
      let sender_balance = coin_store.coin.value;
      requires amount <= sender_balance;
 
      //requires amount < MAX_U64 - sender_balance;
      //requires !features::spec_is_enabled(features::COIN_TO_FUNGIBLE_ASSET_MIGRATION);

      aborts_if false;
 }
}

