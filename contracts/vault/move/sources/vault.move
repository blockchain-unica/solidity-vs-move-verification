module vault_addr::vault {
   use aptos_framework::coin::{Self, Coin};
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    
    const EWaitTimeIsZero : u64 = 0;
    const ENoDistinctKeys : u64 = 1;
    const EAmountIsZero : u64 = 2;
    const ESignerNotAuth : u64 = 3;
    const EWrongTime : u64 = 4;
    const EWrongState : u64 = 5;
    const EInsufficientBalance : u64 = 6;

    const IDLE : u8 = 0;
    const REQ : u8 = 1;

    struct Vault<phantom CoinType> has key {
        recovery: address, // vault recovery address
        wait_time: u64, //in seconds  (i.e. wait_time = 1 <-> 1 second to wait etc)
        coins: coin::Coin<CoinType>, // any coin type can be stored
        state: u8, // 0 -> IDLE, 1 -> REQ
        request_timestamp: u64, // in seconds, when the withdraw request has been made
        amount: u64, // amount to withdraw
        receiver: address, // receiver of the amount withdraw
    }

    // init must be the first function to be called
    public fun init<CoinType>(owner: &signer, recovery: address, wait_time: u64) {
        assert!(wait_time>0, EWaitTimeIsZero);
        assert!(signer::address_of(owner) != recovery, ENoDistinctKeys);

        let vault = Vault {
            recovery: recovery,
            wait_time: wait_time,
            coins: coin::zero<CoinType>(),
            state: IDLE,
            request_timestamp: 0,
            amount: 0,
            receiver: @0x0,
        };

        move_to(owner, vault);
    }

    // ~Solidity: receive() function 
    public entry fun receive<CoinType>(sender : &signer, vault_addr : address, amount : u64) acquires Vault  {
        let coins : Coin<CoinType> = coin::withdraw(sender, amount);
        let vault = borrow_global_mut<Vault<CoinType>>(vault_addr);
        coin::merge(&mut vault.coins, coins);
	}

    public entry fun withdraw<CoinType>(owner: &signer, amount: u64, receiver: address) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(signer::address_of(owner));

        // ~Solidity: amount <= address(this).balance
        assert!(coin::value(&vault.coins) >= amount, EInsufficientBalance);
        // ~Solidity: state == States.IDLE
        assert!(vault.state == IDLE, EWrongState);

        // in Solidity we use block, here timestamps
        vault.request_timestamp = timestamp::now_seconds();
        vault.amount = amount;
        vault.state = REQ;
        vault.receiver = receiver;
    }

    public entry fun finalize<CoinType>(owner: &signer) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(signer::address_of(owner));

        // ~Solidity: state == States.REQ
        assert!(vault.state == REQ, EWrongState);
        // vault.request_timestamp is in seconds, vault.wait_time is interpreted as seconds
        assert!(timestamp::now_seconds() >= vault.request_timestamp + vault.wait_time, EWrongTime);

        vault.state = IDLE;
        coin::deposit<CoinType>(vault.receiver, coin::extract(&mut vault.coins, vault.amount));
    }

    public entry fun cancel<CoinType>(recovery: &signer, owner:address) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(owner);
       
        // ~Solidity: msg.sender == recovery
        assert!(vault.recovery == signer::address_of(recovery), ESignerNotAuth);
        // ~Solidity: state == States.REQ
        assert!(vault.state == REQ, EWrongState);

        vault.state = IDLE;
    }

    #[test_only]
    public fun vault_balance<CoinType>(owner : address) : u64 acquires Vault {
        let vault = borrow_global<Vault<CoinType>>(owner);
        let balance = &vault.coins;
        coin::value(balance)
    }

    #[test_only]
    public fun vault_state<CoinType>(owner : address) : u8 acquires Vault {
        let vault = borrow_global<Vault<CoinType>>(owner);
        vault.state
    }

    #[test_only]
    public fun vault_exists<CoinType>(owner : &signer) : bool {
        exists<Vault<CoinType>>(signer::address_of(owner))
    }
}