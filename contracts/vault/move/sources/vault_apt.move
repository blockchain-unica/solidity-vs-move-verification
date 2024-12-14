module vault_apt::vault {
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    
    // the coin type stored is parameteric
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
        state: u8, // from Move on Aptos 2.0 it is possible to use Enumerations,
        // similar to what is available in Solidity 
        // (but: not know if the capabilities of move prover changes 
        // between version 1.0 and 2.0)
        // from Solidity 
        // 0 -> IDLE
        // 1 -> REQ
        request_timestamp: u64, // in seconds, when the withdraw request has 
        // made
        amount: u64, // amount to withdraw
        receiver: address, // receiver of the amount withdraw
    }

    // initialization between Move and Solidity is slightly different;
    // the function init is not called at publishing time but must be called afterwards
    // (to add behaviour at publishing
    // time it is required to define a function 
    // fun init_module(account: &signer) {...}, less powerful than Solidity constructor)
    // other difference: Move requires 
    // the initialization of all fields
    // while Solidity does not
    public fun init<CoinType>(owner: &signer, recovery: address, wait_time: u64) {
        let vault = Vault {
            owner: signer::address_of(owner),
            recovery: recovery,
            wait_time: wait_time,
            coins: coin::zero<CoinType>(),
            state: 0,
            request_timestamp: 0,
            amount: 0,
            receiver: @0x0,
        };
        move_to(owner, vault);
    }

    // this is the "receive" function 
    // from the Vault specification
    // function defined here follows 
    // the Move naming conventions 
    public fun deposit<CoinType>(owner: address, deposit_amount: Coin<CoinType>) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(owner);
        coin::merge(&mut vault.coins, deposit_amount);
    }

    public fun withdraw<CoinType>(owner: &signer, amount: u64, receiver: address) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(signer::address_of(owner));
        // like msg.sender == owner in Solidity
        assert!(vault.owner == signer::address_of(owner), 0);
        // like amount <= address(this).balance in Solidity
        assert!(coin::value(&vault.coins) >= amount, 1);
        // like state == States.IDLE in Solidity
        assert!(vault.state == 0, 2);

        // Solidity uses block, here timestamps
        vault.request_timestamp = timestamp::now_seconds();
        vault.amount = amount;
        vault.state = 1;
        vault.receiver = receiver;
    }

    public fun finalize<CoinType>(owner: &signer) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(signer::address_of(owner));
        // like msg.sender == owner in Solidity
        assert!(vault.owner == signer::address_of(owner), 0);
        // like state == States.REQ in Solidity
        assert!(vault.state == 1, 1);
        // vault.request_timestamp is in seconds, vault.wait_time is interpreted as seconds
        assert!(timestamp::now_seconds() >= vault.request_timestamp + vault.wait_time, 2);

        vault.state = 0;
        coin::deposit<CoinType>(vault.receiver, coin::extract(&mut vault.coins, vault.amount));
    }

    public fun cancel<CoinType>(recovery: &signer, owner:address) acquires Vault {
        let vault = borrow_global_mut<Vault<CoinType>>(owner);
       
        // extra check (not in Solidity) 
        assert!(vault.owner == owner, 0);
        // like msg.sender == recovery in Solidity
        assert!(vault.recovery == signer::address_of(recovery), 1);
        // like state == States.REQ in Solidity
        assert!(vault.state == 1, 2);

        vault.state = 0;
    }
}
