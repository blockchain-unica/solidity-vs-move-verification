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
    // abort with code 0, location is the module name where the error will be raised
    #[expected_failure(abort_code = 0,location=bank)]
    fun deposit_amount_is_zero_fail(client : &signer, bank : &signer){
        bank::test_init_module(bank); // initialize the Bank resource
        // and give it to the executor of the test_init_module module
        bank::deposit(client,signer::address_of(bank),0);
    }
    
    #[test(client = @0x1,bank = @0xB)]
    // no amount of money provided
    // note that there is no need to mint/burn money like in the following 
    // tests
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
    // simple test, just to check if the deposit work 
    // in a simple case
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
        // we gave him 1000 AptosCoin

        // only for testing purposes, 
        // mint_capability and burn_capability are resources 
        // they need to be destroyed explicitly at the end of the testing function
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

#[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    // test if the deposit updates the amount of money
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
    // test that withdraw 0 is not allowed
    fun test_bank_withdraw_zero(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        // deposit (and create an account in the process) some money 
        // if no deposit were made, the withdraw would fail 
        // due to the nonexisting account in the bank
        // instead of the 0 AptosCoin withdrawn
        bank::deposit(client,signer::address_of(bank),500);
        bank::withdraw(client,signer::address_of(bank),0);
        // fails at withdraw since withdraw 0 is prohibited
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 500,2);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }


#[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    // simple test to check that the withdraw does indeed what it 
    // is supposed to do
    fun test_bank_withdraw(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        // like in the test_bank_withdraw_zero deposit first 
        // to create an account and withdraw immediately after
        bank::deposit(client,signer::address_of(bank),500);
        bank::withdraw(client,signer::address_of(bank),200);
        // check if after a deposit 500 and withdraw 200 of deposit,
        // 300 AptosCoin are inside the bank 
        assert!(bank::account_balance(client,signer::address_of(bank)) == 300,1);
        // and the user account owns 500 (remaining after deposit) 
        // + 200 (what has been withdrawn) 
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 700,2);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }


    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    // it should not be possible to deposit more money than what a 
    // user personally owns (in its aptos account)
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
    // withdraw more money than what the client has in the bank account
    fun test_bank_withdraw_too_much(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        bank::deposit(client,signer::address_of(bank),500); 
        // fails (correctly) here since the amount to deposit is too big 
        // (not enough money in the bank account)
        bank::withdraw(client,signer::address_of(bank),600);
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }



    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    // 
    fun test_overflow_account(client : &signer, bank : &signer, aptos_framework:&signer){
        //counterexample to the prover claim that code does not fail on overflow?
        // the idea of this test is the following:
        // 1 -> give the user the max amount of AptosCo possible in his/her  
        // personal account 
        // 2 -> deposit some money in the client bank account
        // 3 -> restore the max amount of AptosCoin in their account
        // 4 -> withdraw some AptosCoin -> this make the personal account 
        // overflow

        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        let max_u64 = ((1u128 << 64) - 1) as u64;
        // as the name says, it is max_u64 is the maximum value for u64
        // I did not see a library function which gives 
        // the u64 max value, that's why it is done manually 
        give_coins(&mint_capability,client,max_u64);
        // just give some money to withdraw from the 
        // client personal account
        bank::deposit(client,signer::address_of(bank),200);

        give_coins(&mint_capability, client, 200);
        // the amount of money inside the personal account 
        // of the user is now again the max_u64
        // the 200 AptosCoin are just a random amount
        // the previous instructions are needed to 
        // make the next one fail 
        bank::withdraw(client,signer::address_of(bank),200);

        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }


    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    // this test represent the counterexample that the move prover 
    // found while proving the properties 
    // ensures (bank_credits_sender_coin_value_post == 
    //    (bank_credits_sender_coin_value + amount));
    // unfortunately, this test passes since I do not understand 
    // why the prover tells me that the property is not satisfied 
    // maybe something related to the status of the account?
    // genuinly confused by the prover output
    fun test_deposit_assets_credits_ensure_failure(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework); // only for testing purposes, allow to burn and mint  aptos coin
        give_coins(&mint_capability,client,18446744073709545282);

        bank::deposit(client,signer::address_of(bank),2);
        assert!(bank::account_balance(client,signer::address_of(bank)) == 2,1);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 18446744073709545280,2);
        // after the deposit two things: 
        // * the amount of money into the balance of the Bank client 
        // account is 2 
        // * the amount of money into the client personal account is 
        // 18446744073709545280 since 
        // we gave him 18446744073709545282 AptosCoin

        // only for testing purposes, 
        // mint_capability and burn_capability are resources 
        // they need to be destroyed explicitly at the end of the testing function
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    // this test represent the counterexample that the move prover 
    // found while proving the properties 
    // ensures (bank_credits_sender_coin_value_post == 
    //  (bank_credits_sender_coin_value + amount)) && (sender_coins_value_post == (sender_coins_value - amount));
    // unfortunately, this test passes since I do not understand 
    // why the prover tells me that the property is not satisfied 
    // maybe something related to the status of the account?
    // genuinly confused by the prover output
    fun test_deposit_assets_transfer_ensure_failure(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework); // only for testing purposes, allow to burn and mint  aptos coin
        give_coins(&mint_capability,client,2);

        bank::deposit(client,signer::address_of(bank),1);
        assert!(bank::account_balance(client,signer::address_of(bank)) == 1,1);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 1,2);
        // after the deposit two things: 
        // * the amount of money into the balance of the Bank client 
        // account is 1 
        // * the amount of money into the client personal account is 
        // 1 since 
        // we gave him 2 AptosCoin

        // only for testing purposes, 
        // mint_capability and burn_capability are resources 
        // they need to be destroyed explicitly at the end of the testing function
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }


    #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    #[expected_failure]
    // deposit an amount of money which the user does not has 
    // this test fails correctly while the prover seems to state 
    // that the deposit function cannot abort in similar condition
    // the condition: aborts_if sender_coins_value < amount
    // sender_coins_value is the amount of money in the personal 
    // account of the user
    // I don't really understand the counterexample provided by the 
    // prover: seems unrelated to what I want to state 
    // in any case the following test fails correctly
    // showing what i want
    fun test_deposit_revert_abort_failure(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework);
        give_coins(&mint_capability,client,1000);

        // fails at the next instructions since 
        // the user does not own 1001 AptosCoin
        bank::deposit(client,signer::address_of(bank),1001); 
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

 #[test(client = @0xA,bank = @0xB, aptos_framework = @aptos_framework)]
    // this test represent the counterexample that the move prover 
    // found while proving the properties 
    // ensures (bank_credits_sender_coin_value_post == 
    //  (bank_credits_sender_coin_value - amount)) 
    //  && (sender_coins_value_post == (sender_coins_value + amount));
    // unfortunately, this test passes since I do not understand 
    // why the prover tells me that the property is not satisfied 
    // maybe something related to the status of the account?
    // genuinly confused by the prover output
    fun test_withdraw_assets_transfer_ensures_failure(client : &signer, bank : &signer, aptos_framework:&signer){
        bank::test_init_module(bank);
        let (burn_capability, mint_capability) = aptos_coin::initialize_for_test(aptos_framework); // only for testing purposes, allow to burn and mint  aptos coin
        give_coins(&mint_capability,client,5706);
        bank::deposit(client,signer::address_of(bank),5706); 
        bank::withdraw(client,signer::address_of(bank),1);
        assert!(bank::account_balance(client,signer::address_of(bank)) == 5705 ,1);
        assert!(coin::balance<AptosCoin>(signer::address_of(client)) == 1,2);
        // after the withdraw two things: 
        // * the amount of money into the balance of the Bank client 
        // account is 5705 
        // * the amount of money into the client personal account is 
        // 1 since 
        // we gave him 5706 AptosCoin

        // only for testing purposes, 
        // mint_capability and burn_capability are resources 
        // they need to be destroyed explicitly at the end of the testing function
        coin::destroy_mint_cap(mint_capability);
        coin::destroy_burn_cap(burn_capability);
    }

    // regarding the last: withdraw-revert 
    // the prover tells me that the function aborts if 
    // Coin is not published error (ECOIN_STORE_NOT_PUBLISHED)
    // which requires, according 
    // to the documentation on errors to register the coin for the address.
    // adding the spec function that _should_ catch this error 
    // !coin::spec_is_account_registered (...) does not work and 
    // the prover says that the function does not abort under 
    // that condition (i.e. !coin::spec_is_account_registered(...))
    // such function contains a check for the existence of a 
    // (primary) store so I don't understand what is going on here

}
