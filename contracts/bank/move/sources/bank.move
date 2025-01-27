module bank_addr::bank {

    use std::coin::{Self,Coin};
    use aptos_framework::aptos_coin::AptosCoin;
    use std::signer;
    use std::simple_map::{Self, SimpleMap};

    struct Bank has key, store {
        credits : SimpleMap<address, Coin<AptosCoin>>,
        opLimit : u64,
    }

    const EWrongAmount : u64 = 0;
    const ENoAccount : u64 = 1;

    public fun init(account : &signer, opLimit : u64) {
        assert!(opLimit>0, EWrongAmount);

        let bank = Bank{
            credits : simple_map::new(),
            opLimit : opLimit,
        };
        move_to(account, bank);
    }

    // ~Solidity: deposit is allowed only to msg.sender (the transaction signer)
    public entry fun deposit(sender : &signer, owner : address, amount : u64) acquires Bank  {
        // ~Solidity: require(amount > 0);
        assert!(amount > 0, EWrongAmount);

        let bank = borrow_global_mut<Bank>(owner); 

        if (signer::address_of(sender) != owner)
            assert!(amount <= bank.opLimit, EWrongAmount);

        let deposit : Coin<AptosCoin> = coin::withdraw(sender, amount);

        // the sender has already credits in the bank
        if (simple_map::contains_key(&bank.credits, &signer::address_of(sender))){
            let coin_available = simple_map::borrow_mut(&mut bank.credits, &signer::address_of(sender));
            // new coin balance = current balance + old balance
            coin::merge(coin_available, deposit); 
        } 
        // otherwise, if sender has no credits yet
        else {
            // initialize the sender credits with the deposit
            simple_map::add(&mut bank.credits, signer::address_of(sender), deposit);
        }
    }

    public entry fun withdraw(sender : &signer, owner : address, amount : u64) acquires Bank {
        // ~Solidity: require(amount > 0);
        assert!(amount != 0, EWrongAmount);

        let bank = borrow_global_mut<Bank>(owner);

        if (signer::address_of(sender) != owner)
            assert!(amount <= bank.opLimit, EWrongAmount);

        let sender_balance = simple_map::borrow_mut(&mut bank.credits, &signer::address_of(sender));
	
        let withdrawn = coin::extract(sender_balance, amount);
        coin::deposit<AptosCoin>(signer::address_of(sender), withdrawn);
    }

    #[test_only]
    public fun bank_exists(initiator : &signer) : bool {
        exists<Bank>(signer::address_of(initiator))
    }

    #[test_only]
    public fun balance_of(account : address, bank : address) : u64 acquires Bank {
        let bank = borrow_global<Bank>(bank);
        let balance = simple_map::borrow(&bank.credits, &account);
        coin::value(balance)
    }
}