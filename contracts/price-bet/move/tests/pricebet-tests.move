#[test_only]
module pricebet_addr::pricebet_tests {
    use pricebet_addr::pricebet::{Self};
    use oracle_addr::oracle::{Self};
    use std::signer;
    use std::timestamp; 

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

    // pricebet should exists after its initialization with init_module
    #[test(owner = @0x01, oracle = @0x02, aptos_framework = @aptos_framework)]
    fun test_pricebet_exists(owner : &signer, oracle : address, aptos_framework: &signer) {
        timestamp::set_time_has_started_for_testing(aptos_framework);
        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_cap, owner, 10);

        pricebet::init<AptosCoin>(owner, 1, oracle, 200, 3);
        assert!(pricebet::pricebet_exists<AptosCoin>(owner),0);
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    #[test(owner = @0x01, oracle = @0x02, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_init_zero_initial_pot(owner : &signer, oracle: address, aptos_framework: &signer) {
        timestamp::set_time_has_started_for_testing(aptos_framework);
        pricebet::init<AptosCoin>(owner, 0, oracle, 200, 3);
    }

    #[test(owner = @0x01, oracle = @0x02, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_init_twice(owner : &signer, oracle: address, aptos_framework: &signer) {
        timestamp::set_time_has_started_for_testing(aptos_framework);
        pricebet::init<AptosCoin>(owner, 100, oracle, 200, 3);
        pricebet::init<AptosCoin>(owner, 100, oracle, 200, 3);
    }

    #[test(player = @0x02, owner = @0x03, oracle = @0x04, aptos_framework = @aptos_framework)]
    fun test_join(player : &signer, owner : &signer, oracle : address, aptos_framework: &signer) {

        timestamp::set_time_has_started_for_testing(aptos_framework);
        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, owner, 10);
        give_coins(&mint_cap, player, 10);

        let addr_owner = signer::address_of(owner);
        let addr_player = signer::address_of(player);

        pricebet::init<AptosCoin>(owner, 1, oracle, 200, 3);

        assert!(coin::balance<AptosCoin>(addr_owner) == 9, 0);

        pricebet::join<AptosCoin>(player, addr_owner, 1);
    
        // checks the player and contract' balance after the join
        assert!(coin::balance<AptosCoin>(addr_player) == 9, 0);
        assert!(pricebet::get_balance<AptosCoin>(addr_owner) == 2, 0);

        // mint and burn capabilities must be destroyed at the end of the function
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    #[test(player = @0x02, owner = @0x03, oracle = @0x04, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_join_twice(player : &signer, owner : &signer, oracle : address, aptos_framework: &signer) {

        timestamp::set_time_has_started_for_testing(aptos_framework);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, owner, 10);
        give_coins(&mint_cap, player, 10);

        let addr_owner = signer::address_of(owner);

        pricebet::init<AptosCoin>(owner, 1, oracle, 200, 3);

        pricebet::join<AptosCoin>(player, addr_owner, 1);
        pricebet::join<AptosCoin>(player, addr_owner, 1);
    
        // mint and burn capabilities must be destroyed at the end of the function
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    #[test(player = @0x02, owner = @0x03, oracle = @0x04, aptos_framework = @aptos_framework)]
    fun test_player_wins(player : &signer, owner : &signer, oracle : &signer, aptos_framework: &signer) {
        // block::initialize_for_test(aptos_framework, 1000);
        timestamp::set_time_has_started_for_testing(aptos_framework);

        oracle::test_init_module(oracle);
        let addr_oracle = signer::address_of(oracle);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, owner, 10);
        give_coins(&mint_cap, player, 10);

        let addr_owner = signer::address_of(owner);
        let addr_player = signer::address_of(player);

        // target exchange rate is 3
        pricebet::init<AptosCoin>(owner, 1, addr_oracle, 200, 3);

        assert!(coin::balance<AptosCoin>(addr_owner) == 9, 0);

        pricebet::join<AptosCoin>(player, addr_owner, 1);
    
        // checks the player and contract' balance after the join
        assert!(coin::balance<AptosCoin>(addr_player) == 9, 0);
        assert!(pricebet::get_balance<AptosCoin>(addr_owner) == 2, 0);

        // actual exchange rate is 5
        oracle::set_exchange_rate(oracle, 5);

        pricebet::win<AptosCoin>(player, addr_owner);

        // checks the player and contract' balance after the win
        assert!(coin::balance<AptosCoin>(addr_player) == 11, 0);
        assert!(pricebet::get_balance<AptosCoin>(addr_owner) == 0, 0);

        // mint and burn capabilities must be destroyed at the end of the function
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    #[test(player = @0x02, owner = @0x03, oracle = @0x04, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_player_loses(player : &signer, owner : &signer, oracle : &signer, aptos_framework: &signer) {
        // block::initialize_for_test(aptos_framework, 1000);
        timestamp::set_time_has_started_for_testing(aptos_framework);

        oracle::test_init_module(oracle);
        let addr_oracle = signer::address_of(oracle);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, owner, 10);
        give_coins(&mint_cap, player, 10);

        let addr_owner = signer::address_of(owner);
        let addr_player = signer::address_of(player);

        // target exchange rate is 3
        pricebet::init<AptosCoin>(owner, 1, addr_oracle, 200, 3);

        assert!(coin::balance<AptosCoin>(addr_owner) == 9, 0);

        pricebet::join<AptosCoin>(player, addr_owner, 1);
    
        // checks the player and contract' balance after the join
        assert!(coin::balance<AptosCoin>(addr_player) == 9, 0);
        assert!(pricebet::get_balance<AptosCoin>(addr_owner) == 2, 0);

        // actual exchange rate is 2 (player does not win)
        oracle::set_exchange_rate(oracle, 2);

        pricebet::win<AptosCoin>(player, addr_owner);

        // checks the player and contract' balance after the win
        assert!(coin::balance<AptosCoin>(addr_player) == 11, 0);
        assert!(pricebet::get_balance<AptosCoin>(addr_owner) == 0, 0);

        // mint and burn capabilities must be destroyed at the end of the function
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    #[test(player = @0x02, owner = @0x03, oracle = @0x04, aptos_framework = @aptos_framework)]
    fun test_owner_wins(player : &signer, owner : &signer, oracle : &signer, aptos_framework: &signer) {
        // block::initialize_for_test(aptos_framework, 1000);
        timestamp::set_time_has_started_for_testing(aptos_framework);

        oracle::test_init_module(oracle);
        let addr_oracle = signer::address_of(oracle);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, owner, 10);
        give_coins(&mint_cap, player, 10);

        let addr_owner = signer::address_of(owner);
        let addr_player = signer::address_of(player);

        // target exchange rate is 3
        // deadline is 200 seconds
        pricebet::init<AptosCoin>(owner, 1, addr_oracle, 200, 3);

        assert!(coin::balance<AptosCoin>(addr_owner) == 9, 0);

        pricebet::join<AptosCoin>(player, addr_owner, 1);
    
        // checks the player and contract' balance after the join
        assert!(coin::balance<AptosCoin>(addr_player) == 9, 0);
        assert!(pricebet::get_balance<AptosCoin>(addr_owner) == 2, 0);

        // actual exchange rate is 2
        oracle::set_exchange_rate(oracle, 2);

        // deadline expired
        timestamp::fast_forward_seconds(200); 

        pricebet::timeout<AptosCoin>(addr_owner);

        // checks the player, owner and contract' balance after the timeout
        assert!(coin::balance<AptosCoin>(addr_player) == 9, 0);
        assert!(coin::balance<AptosCoin>(addr_owner) == 11, 0);
        assert!(pricebet::get_balance<AptosCoin>(addr_owner) == 0, 0);

        // mint and burn capabilities must be destroyed at the end of the function
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }
}