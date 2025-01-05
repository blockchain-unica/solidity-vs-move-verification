#[test_only]
module vault_addr::vault_tests {
    #[test_only]
    use vault_addr::vault::{Self}; 
    #[test_only]
    use aptos_framework::account::{Self};
    #[test_only]
    use aptos_framework::aptos_coin::{Self,AptosCoin};
    #[test_only]
    use aptos_framework::coin::{Self, MintCapability};

    #[test(owner = @0x01, recovery = @0x02)]
    #[expected_failure]
    public fun test_init_owner_eq_recovery(owner : &signer, recovery: address) {
        vault::init<AptosCoin>(owner, recovery, 0);
    }

    #[test(owner = @0x01, recovery = @0x01)]
    #[expected_failure]
    public fun test_init_zero_wait_time(owner : &signer, recovery: address) {
        vault::init<AptosCoin>(owner, recovery, 100);
    }


    #[test(owner = @0x01, recovery = @0x02)]
    #[expected_failure]
    public fun test_init_twice(owner : &signer, recovery: address) {
        vault::init<AptosCoin>(owner, recovery, 100);
        vault::init<AptosCoin>(owner, recovery, 100);
    }

    // #[test(initiator = @0x02, sender = @0x03, aptos_framework = @0x01)]
    // public fun test_withdraw(owner : &signer, aptos_framework: &signer) acquires Vault {
    //     // init_module(initiator);
    //     let addr_vault = signer::address_of(initiator);

    //     let (burn_cap,mint_cap) = aptos_framework::aptos_coin::initialize_for_test(aptos_framework);

    //     let a = account::create_account_for_test(@0x3);
    //     let addr_a = signer::address_of(&a);

    //     coin::register<AptosCoin>(&a);
    //     0x1::aptos_coin::mint(aptos_framework, @0x3, 10);

    //     let init_balance = coin::balance<AptosCoin>(addr_a);
    //     assert!(init_balance == 10, 0);

    //     withdraw(&a, addr_vault, 1);
    //     assert!(coin::balance<AptosCoin>(addr_a) == init_balance - 1, 0);
    
    //     assert!(balance_of(addr_a, addr_vault) == 2, 0);

    //     coin::destroy_burn_cap(burn_cap);
    //     coin::destroy_mint_cap(mint_cap);
    // }
}