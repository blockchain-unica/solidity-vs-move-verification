#[test_only]
module vault_addr::vault_tests {
    use vault_addr::vault::{Self};
    use std::signer;

    use aptos_framework::account::{Self};
    use aptos_framework::aptos_coin::{AptosCoin};
    use aptos_framework::coin::{Self, MintCapability};

    // helper function to create an account with freshly minted coins
    #[test_only]
    fun give_coins(mint_capability: &MintCapability<AptosCoin>, to: &signer, amount : u64) {
        let to_addr = signer::address_of(to);
        // signer is the executor of the transaction
        if (!account::exists_at(to_addr)) { // if no account exists for to_addr...
            // ... creates a new account for it
            account::create_account_for_test(to_addr);
        };
        // allows to store coins for the receiver of the funds
        coin::register<AptosCoin>(to);
        let coins = coin::mint(amount, mint_capability);
        coin::deposit(to_addr, coins);
    }

    // // vault should exists after its initialization with init_module
    // #[test(owner = @0x01, recovery = @0x02)]
    // fun test_vault_exists(owner : &signer, recovery : address){
    //     vault::init<AptosCoin>(owner, recovery, 100);
    //     assert!(vault::vault_exists(vault),0);
    // }

    #[test(owner = @0x01, recovery = @0x02)]
    #[expected_failure]
    fun test_init_owner_eq_recovery(owner : &signer, recovery: address) {
        vault::init<AptosCoin>(owner, recovery, 0);
    }

    #[test(owner = @0x01, recovery = @0x01)]
    #[expected_failure]
    fun test_init_zero_wait_time(owner : &signer, recovery: address) {
        vault::init<AptosCoin>(owner, recovery, 100);
    }

    #[test(owner = @0x01, recovery = @0x02)]
    #[expected_failure]
    fun test_init_twice(owner : &signer, recovery: address) {
        vault::init<AptosCoin>(owner, recovery, 100);
        vault::init<AptosCoin>(owner, recovery, 100);
    }

    // signer a performs two deposits of 1 AptosCoin each
    // check that the balances of the signer a and of the bank are correct
    #[test(a = @0x01, owner = @0x03, recovery = @0x04, aptos_framework = @aptos_framework)]
    fun test_receive(a : &signer, owner : &signer, recovery : address, aptos_framework: &signer) {
        vault::init<AptosCoin>(owner, recovery, 100);
        let addr_owner = signer::address_of(owner);
        let addr_a = signer::address_of(a);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);
 
        // creates a new account for test, and mints for it 10 AptosCoin
        give_coins(&mint_cap, a, 10);

        // checks if the initial balance of a is 10
        let init_balance = coin::balance<AptosCoin>(addr_a);
        assert!(init_balance == 10, 0);

        // checks the balance of owner after the first deposit
        vault::receive<AptosCoin>(a, addr_owner, 1);
        assert!(coin::balance<AptosCoin>(addr_a) == init_balance - 1, 0);

        // checks the balance of owner after the second deposit
        vault::receive<AptosCoin>(a, addr_owner, 1);
        assert!(coin::balance<AptosCoin>(addr_a) == init_balance - 2, 0);
    
        // checks the balance of the vault after the two deposits
        assert!(vault::vault_balance<AptosCoin>(addr_owner) == 2, 0);

        // mint and burn capabilities must be destroyed at the end of the function
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

}