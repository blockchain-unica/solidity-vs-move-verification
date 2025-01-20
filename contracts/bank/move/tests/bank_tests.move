// [test_only] function is available only under tests (e.g. when we call `aptos move test`)
#[test_only]
module bank_addr::bank_tests {
    use bank_addr::bank::{Self}; 
    use std::signer;

    // aptos_framework needed to get the mint and burn capability for AptosCoin 
    use aptos_framework::account::{Self};
    use aptos_framework::aptos_coin::{Self,AptosCoin}; 
    use aptos_framework::coin::{Self, MintCapability}; // (used in give_coins)

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

    // bank should exists after its initialization with init_module
    #[test(initiator = @0xB)]
    fun test_bank_exists(initiator : &signer){
        bank::init(initiator, 1);
        assert!(bank::bank_exists(initiator),0);
    }
 
    // init cannot be called twice
    #[test(initiator = @0x01)]
    #[expected_failure]
    public fun test_init_twice(initiator : &signer){
        bank::init(initiator, 1);
        bank::init(initiator, 1);
    }

    // deposit of zero tokens should fail
    #[test(sender = @0x1, bank = @0xB)]
    // expected_failure <-> the test is successful if it fails with abort code EWrongAmount 
    #[expected_failure(abort_code = bank::EWrongAmount)]
    fun test_deposit_amount_zero(sender : &signer, bank : &signer) {
        bank::init(bank, 1000); // initialize the Bank resource and pass it to bank::test_init_module
        bank::deposit(sender, signer::address_of(bank), 0);
    }

    // signer a performs two deposits of 1 AptosCoin each
    // check that the balances of the signer a and of the bank are correct
    #[test(a = @0x03, bank = @0xB, aptos_framework = @aptos_framework)]
    fun test_deposit(a : &signer, bank : &signer, aptos_framework: &signer) {
        bank::init(bank, 1000);
        let addr_bank = signer::address_of(bank);
        let addr_a = signer::address_of(a);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);
 
        // creates a new account for test, and mints for it 10 AptosCoin
        give_coins(&mint_cap, a, 10);

        // checks if the initial balance of a is 10
        let init_balance = coin::balance<AptosCoin>(addr_a);
        assert!(init_balance == 10, 0);

        // checks the balance of a after the first deposit
        bank::deposit(a, addr_bank, 1);
        assert!(coin::balance<AptosCoin>(addr_a) == init_balance - 1, 0);

        // checks the balance of a after the second deposit
        bank::deposit(a, addr_bank, 1);
        assert!(coin::balance<AptosCoin>(addr_a) == init_balance - 2, 0);
    
        // checks the balance of the bank after the two deposits
        assert!(bank::balance_of(addr_a, addr_bank) == 2, 0);

        // mint and burn capabilities must be destroyed at the end of the function
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    // deposit of more coins than what the signer owns should fail
    #[test(a = @0xA, bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_deposit_more_than_balance(a : &signer, bank : &signer, aptos_framework : &signer) {
        bank::init(bank, 2000);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, a, 1000);

        bank::deposit(a,signer::address_of(bank), 1001);

        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }

    // deposit of more coins than opLimit should fail (if the sender is not the bank owner)
    #[test(a = @0xA, bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_deposit_more_than_oplimit(a : &signer, bank : &signer, aptos_framework : &signer) {
        bank::init(bank, 10);

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, a, 1000);

        bank::deposit(a,signer::address_of(bank), 11);

        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }

    // deposit of more coins than opLimit should not fail (if the sender is the bank owner)
    #[test(owner = @0xB, aptos_framework = @aptos_framework)]
    fun test_deposit_more_than_oplimit_owner(owner : &signer, aptos_framework : &signer) {
        bank::init(owner, 10);

        let addr_owner = signer::address_of(owner);
        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, owner, 1000);

        bank::deposit(owner,addr_owner, 11);

        assert!(coin::balance<AptosCoin>(addr_owner) == 1000-11, 0);

        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }

    // bank owner deposits coins (owner's address == bank's address)
    #[test(owner = @0xB, aptos_framework = @aptos_framework)]
    fun test_deposit_owner(owner : &signer, aptos_framework : &signer) {
        bank::init(owner, 10);

        let addr_owner = signer::address_of(owner);
        let addr_bank = addr_owner;

        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, owner, 100);

        bank::deposit(owner,addr_bank, 20);

        assert!(coin::balance<AptosCoin>(addr_owner) == 80, 0);
        assert!(bank::balance_of(addr_owner, addr_bank) == 20, 0);

        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }

    // withdraw without a previous deposit should fail
    #[test(a = @0xA, bank = @0xB)]
    #[expected_failure(abort_code = bank::EWrongAmount)]
    fun test_withdraw_without_deposit(a : &signer, bank : &signer) {
        bank::init(bank, 1000);
        bank::withdraw(a,signer::address_of(bank),0);
    }

    // withdraw zero amount should fail
    #[test(a = @0xA, bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure(abort_code=bank::EWrongAmount)]
    fun test_withdraw_zero(a : &signer, bank : &signer, aptos_framework : &signer){
        bank::init(bank, 1000);
        let addr_bank = signer::address_of(bank);
        let addr_a = signer::address_of(a);
        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, a, 1000);

        bank::deposit(a, addr_bank, 500);
        bank::withdraw(a, addr_bank, 0);
        assert!(coin::balance<AptosCoin>(addr_a) == 500, 2);

        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);
    }

    // signer a performs one deposits of 1000 AptosCoin and two withdraws
    // check that the balances of the signer a and of the bank are correct
    #[test(a = @0xA, bank = @0xB, aptos_framework = @aptos_framework)]
    fun test_withdraw(a : &signer, bank : &signer, aptos_framework : &signer) {
        bank::init(bank, 1000);
        let addr_bank = signer::address_of(bank);
        let addr_a = signer::address_of(a);
        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        let init_balance = 1000;
        let dep_amount = 500;
        let wd_amount = 200;

        give_coins(&mint_cap, a, init_balance);
        
        bank::deposit(a, addr_bank, dep_amount);

        // post-deposit checks
        assert!(coin::balance<AptosCoin>(addr_a) == init_balance - dep_amount, 0);
        assert!(bank::balance_of(addr_a, addr_bank) == dep_amount, 0);

        bank::withdraw(a, addr_bank, wd_amount);

        // post-withdraw checks
        assert!(bank::balance_of(addr_a, addr_bank) == dep_amount - wd_amount, 0);
        assert!(coin::balance<AptosCoin>(addr_a) == init_balance-dep_amount+wd_amount, 2);

        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }

    // withdrawing more tokens than the sender's credit should fail
    #[test(a = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_withdraw_too_much(a : &signer, bank : &signer, aptos_framework:&signer){
        bank::init(bank, 1000);
        let addr_bank = signer::address_of(bank);
        let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

        give_coins(&mint_cap, a, 1000);

        let dep_amount : u64= 500;
        let wd_amount : u64 = 501;

        bank::deposit(a,addr_bank, dep_amount); 

        // must fail here, since the amount to withdraw is too much 
        bank::withdraw(a, addr_bank, wd_amount);

        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }

    // Check that overflows on users' accounts are handled correctly:
    // 1) give the user the max amount of AptosCoin 
    // 2) deposit some more AptosCoin in the client bank account
    // 3) restore the max amount of AptosCoin in their account
    // 4) withdraw some AptosCoin -> this should overflow
    #[test(a = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_overflow_account(a : &signer, bank : &signer, aptos_framework:&signer) {
        bank::init(bank, 1000);
        let addr_bank = signer::address_of(bank);
        let addr_a = signer::address_of(a);

        let (burn_cap, mint_cap) = aptos_coin::initialize_for_test(aptos_framework);
    
        // let max_u64 = ((1u128 << 64) - 1) as u64;
        let max_u64 : u64 = 0xFFFFFFFFFFFFFFFF;
        let dep_amount : u64 = 1;

        give_coins(&mint_cap, a, max_u64);
        assert!(bank::balance_of(addr_a, addr_bank) == max_u64, 0);

        bank::deposit(a, addr_bank, dep_amount);

        give_coins(&mint_cap, a, dep_amount);
        assert!(bank::balance_of(addr_a, addr_bank) == max_u64, 0);

        // the withdraw should fail 
        bank::withdraw(a, addr_bank, dep_amount);

        coin::destroy_mint_cap(mint_cap);
        coin::destroy_burn_cap(burn_cap);
    }
}
