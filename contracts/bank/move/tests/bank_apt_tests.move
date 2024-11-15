#[test_only]
module bank_apt::bank_apt_tests {
    #[test_only]
    use std::signer;
    #[test_only]
    use bank_apt::bank::{Self};
    #[test_only]
    use aptos_framework::account::{Self};
    #[test_only]
    use aptos_framework::aptos_coin::{Self,AptosCoin};
    #[test_only]
    use aptos_framework::coin::{Self, MintCapability};

    #[test_only]
    fun give_coins(mint_capability: &MintCapability<AptosCoin>, to: &signer, amount : u64) {
        let to_addr = signer::address_of(to);
        // required to correctly deposit coin further below
        if (!account::exists_at(to_addr)) {
            account::create_account_for_test(to_addr);
        };
        // allow to store coins for the receiver of the funds
        coin::register<AptosCoin>(to);
        //
        let coins = coin::mint(amount, mint_capability);
        coin::deposit(to_addr, coins);
    }
    // #[test] still required since
    // even if module is declared 
    // for test only
   #[test(client = @0x1,bank = @0xB)]
    // no amount of money provided
    #[expected_failure(abort_code = 0,location=bank)]
    fun deposit_amount_is_zero_fail(client : &signer, bank : &signer){
        bank::test_init_module(bank);
        bank::deposit(client,signer::address_of(bank),0);
    }
    
    #[test(client = @0x1,bank = @0xB)]
    // no amount of money provided
    #[expected_failure(abort_code = 0,location=bank)]
    fun amount_is_zero_fail(client : &signer, bank : address){
        bank::withdraw(client,bank,0);
    }

    #[test(bank = @0xB)]
    fun test_bank_existence(bank : &signer){
        bank::test_init_module(bank);
        assert!(bank::bank_exists(bank),0);
    }

    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    fun test_bank_deposit(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        bank::deposit(client,signer::address_of(bank),500);
        assert!(bank::account_balance(client,signer::address_of(bank)) == 500,1);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 500,2);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

#[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    fun test_bank_update_deposit(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        bank::deposit(client,signer::address_of(bank),500);
        bank::deposit(client,signer::address_of(bank),200);
        assert!(bank::account_balance(client,signer::address_of(bank)) == 700,1);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 300,2);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

#[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure(abort_code=0, location=bank)]
    fun test_bank_withdraw_zero(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        bank::deposit(client,signer::address_of(bank),500);
        bank::withdraw(client,signer::address_of(bank),0);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 500,2);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }


#[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    fun test_bank_withdraw(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        bank::deposit(client,signer::address_of(bank),500);
        bank::withdraw(client,signer::address_of(bank),200);
        assert!(bank::account_balance(client,signer::address_of(bank)) == 300,1);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 700,2);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }


    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_bank_deposit_too_much(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        // fails here since the amount to deposit is too big 
        // (not enough money in the account )
        bank::deposit(client,signer::address_of(bank),1500);
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_bank_withdraw_too_much(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        // fails here since the amount to deposit is too big 
        // (not enough money in the account )
        bank::deposit(client,signer::address_of(bank),500);
        bank::withdraw(client,signer::address_of(bank),600);
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }



    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    fun test_overflow_account(client : &signer, bank : &signer, aptos_framework:&signer){
        //counterexample to the prover claim that code does not fail on overflow?
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        let max_u64 = ((1u128 << 64) - 1) as u64;
        give_coins(&mint_capability,client,max_u64);

        bank::deposit(client,signer::address_of(bank),200);

        give_coins(&mint_capability, client, 200);

        // next instruction fails due to overflow
        bank::withdraw(client,signer::address_of(bank),200);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }
}
