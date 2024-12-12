// [test_only] function is available only under tests 
// like when we call `aptos move test`
#[test_only]
module bank_apt::bank_apt_tests {
    #[test_only]
    use std::signer; // to call signer related functions
    #[test_only]
    use bank_apt::bank::{Self}; 
    #[test_only]
    use aptos_framework::account::{Self};
    #[test_only]
    use aptos_framework::aptos_coin::{Self,AptosCoin};
    #[test_only]
    use aptos_framework::coin::{Self, MintCapability};
    // Mint capability: capability to mint coins 
    // without it it is not possible to create new coins
    // this capability is used in the function give_coins below

    // helper function to allow to give coins to a user
    #[test_only]
    fun give_coins(mint_capability: &MintCapability<AptosCoin>, to: &signer, amount : u64) {
        let to_addr = signer::address_of(to);
        // recall that signer is the executor of the transaction
        if (!account::exists_at(to_addr)) { // if no account is available
            // it is not possible to deposit money into it -> not possible 
            // to do any test involving money
            account::create_account_for_test(to_addr);
        };
        // allow to store coins for the receiver of the funds
        coin::register<AptosCoin>(to);
        let coins = coin::mint(amount, mint_capability);
        coin::deposit(to_addr, coins);
    }
    // #[test] still required since
    // even if module is declared 
    // for test only
    // client and bank will have the address 0x1 and 0x2
    // for this test, observe that they match the name of 
    // function parameters
   #[test(client = @0x1,bank = @0xB)]
    // no amount of money provided
    // expected_failure <-> the test is successful if it fails with the
    // abort with code 0, location is where the error will be raised
    #[expected_failure(abort_code = 0,location=bank)]
    fun deposit_amount_is_zero_fail(client : &signer, bank : &signer){
        bank::test_init_module(bank); // initialize the Bank resource
        // and give it to the executor of the test_init_module module
        bank::deposit(client,signer::address_of(bank),0);
    }
    
    #[test(client = @0x1,bank = @0xB)]
    // no amount of money provided
    #[expected_failure(abort_code = 0,location=bank)]
    fun amount_is_zero_fail(client : &signer, bank : address){
        bank::withdraw(client,bank,0);
    }

    #[test(bank = @0xB)]
    // bank should exists after its initialization
    fun test_bank_existence(bank : &signer){
        bank::test_init_module(bank);
        assert!(bank::bank_exists(bank),0);
    }

    // aptos_framework required for allowing to get the mint and burn 
    // capability for AptosCoin 
    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    fun test_bank_deposit(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework); // only for testing purposes, allow to burn and mint  aptos coin
        give_coins(&mint_capability,client,1000);

        bank::deposit(client,signer::address_of(bank),500);
        assert!(bank::account_balance(client,signer::address_of(bank)) == 500,1);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 500,2);
        // after the deposit two things: 
        // * the amount of money into the balance of the Bank client account is 500 
        // * the amount of money into the client personal account is 500 since 
        // we give him 1000 AptosCoin

        // only for testing purposes, 
        // mint_capability and burn_capability are resources 
        // they need to be destroyed explicitly at the end of the testing function
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

#[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    fun test_bank_update_deposit(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);
        // only to check that two deposits work as intended 
        // (for example: after a deposit of 500 and 200 AptosCoin the account
        // should have 700 instead of 200, the last deposit)
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
        // fails at withdraw since withdraw 0 is prohibited
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
        // check if after a deposit 500 and withdraw 200 of deposit,
        // 300 AptosCoin are inside the bank 
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
        // (not enough money in the signer personal account, 1500 > 1000)
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
        // as the name says, it is max_u64 is the maximum value for u64
        // I did not see a library function which gives 
        // the u64 max value, that's why it is done manually 
        give_coins(&mint_capability,client,max_u64);

        bank::deposit(client,signer::address_of(bank),200);

        give_coins(&mint_capability, client, 200);
        // the 200 AptosCoin are just a random amount
        // the previous instructions are needed to 
        // make the next one fail 
        // the idea of this test is the following:
        // 1 -> give the user the max amount of AptosCo possible in his/her  
        // personal account 
        // 2 -> deposit some money in the client bank account
        // 3 -> restore the max amount of AptosCoin in their account
        // (any amount between 1 and 200 is ok btw)
        // 4 -> make this test fail due to withdrawing 
        // an amount of money which will make the personal 
        // account balance overflow
        bank::withdraw(client,signer::address_of(bank),200);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }
}
