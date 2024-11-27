module bank_apt::bank {

    use std::coin::{Self,Coin};
    use aptos_framework::aptos_coin::AptosCoin;
    use std::signer;
    use std::simple_map::{Self, SimpleMap};
    // use aptos_std::type_info;
    // mapping users -> coin(amount)
    // using default coin since 
    // transaction with generics are not
    // supported apparently
    struct Bank has key, store {
        credits : SimpleMap<address, Coin<AptosCoin>>,
    }

    const EAmountIsZero : u64 = 0;
    const ENoAccount : u64 = 1;

    // guaranteed to be called once only
    // by move on aptos rule
    fun init_module(account : &signer) {
        let bank = Bank{
            credits : simple_map::new()
        };
        move_to(account,bank);
    }

    // deposit is allowed only to the signer of the transaction (consistently with solidity implementation)
    public entry fun deposit(sender : &signer, bank : address, amount : u64) acquires Bank  {
        assert!(amount > 0,EAmountIsZero);
        let deposit : Coin<AptosCoin> = coin::withdraw(sender,amount);
        let bank = borrow_global_mut<Bank>(bank); 
        if (simple_map::contains_key(&bank.credits,&signer::address_of(sender))){
            // exists already the account
            // so the new coin balance
            // must be the sum of the current balance + the old balance
            let coin_available = simple_map::borrow_mut(&mut bank.credits, &signer::address_of(sender));
            coin::merge(coin_available,deposit); 
        } else {
            // balance does not exists already
            // initialize the account with 
            // the money deposited

            simple_map::add(&mut bank.credits, signer::address_of(sender), deposit);
        }
    }

    
    //
    public entry fun withdraw(sender : &signer, bank : address, amount : u64) acquires Bank {
        // do not withdraw 0 
        assert!(amount != 0,EAmountIsZero);
        let bank = borrow_global_mut<Bank>(bank);
        let current_balance = simple_map::borrow_mut(&mut bank.credits, &signer::address_of(sender));
        let withdrawn = coin::extract(current_balance,amount);
        // coin::deposit(signer::address_of(sender), withdrawn);
        coin::deposit<AptosCoin>(signer::address_of(sender),withdrawn);
    }

    #[test_only]
    public fun test_init_module(initiator : &signer){
        init_module(initiator);
    }
    #[test_only]
    public fun bank_exists(initiator : &signer) : bool {
        exists<Bank>(signer::address_of(initiator))
    }
    #[test_only]
    public fun account_balance(account : &signer, bank : address) : u64 acquires Bank {
        let bank = borrow_global<Bank>(bank);
        let balance = simple_map::borrow(&bank.credits,&signer::address_of(account));
        coin::value(balance)
    }
}
