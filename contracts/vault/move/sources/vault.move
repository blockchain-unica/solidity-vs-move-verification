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

    // the coin type stored is parametric
    // seems slightly different from the valut requirements 
    // which requires the native currency 
    // the phantom modifier for the generic
    // acts as an "hidden" type parameter
    // in general the behaviour should be the same 
    // since this hidden parameter does not change the 
    // behaviour of the coin functions 
    // but acts only as marker
    struct Vault<phantom CoinType> has key {
        owner: address, // vault owner 
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
            owner: signer::address_of(owner),
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
	let old_r = vault.recovery;
	vault.recovery = vault.owner;
	//vault.recovery = old_r;
	}

    public entry fun withdraw<CoinType>(owner: &signer, amount: u64, receiver: address) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(signer::address_of(owner));

        // ~Solidity: msg.sender == owner
        assert!(vault.owner == signer::address_of(owner), ESignerNotAuth);
        // ~Solidity: amount <= address(this).balance
        assert!(coin::value(&vault.coins) >= amount, EInsufficientBalance);
        // ~Solidity: state == States.IDLE
        assert!(vault.state == IDLE, EWrongState);

        // Solidity uses block, here timestamps
        vault.request_timestamp = timestamp::now_seconds();
        vault.amount = amount;
        vault.state = REQ;
        vault.receiver = receiver;
        //let old_r = vault.recovery;
	//vault.recovery =@0x0123;
        //vault.recovery = old_r;

}

    public entry fun finalize<CoinType>(owner: &signer) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(signer::address_of(owner));
        // ~Solidity: msg.sender == owner
        assert!(vault.owner == signer::address_of(owner), ESignerNotAuth);
        // ~Solidity: state == States.REQ
        assert!(vault.state == REQ, EWrongState);
        // vault.request_timestamp is in seconds, vault.wait_time is interpreted as seconds
        assert!(timestamp::now_seconds() >= vault.request_timestamp + vault.wait_time, EWrongTime);

        vault.state = IDLE;
        coin::deposit<CoinType>(vault.receiver, coin::extract(&mut vault.coins, vault.amount));
    }

    public entry fun cancel<CoinType>(recovery: &signer, owner:address) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(owner);
       
        // extra check (not in Solidity) 
        assert!(vault.owner == owner, ESignerNotAuth);
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
