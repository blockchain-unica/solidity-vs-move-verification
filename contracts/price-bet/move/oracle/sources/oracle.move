module oracle_addr::oracle {
    use aptos_framework::signer;

    struct Oracle has key {
        exchange_rate: u64,
    }

    fun init_module(owner : &signer) {
        let oracle = Oracle{
            exchange_rate: 0,
        };
        move_to(owner, oracle);
    }

    public fun get_exchange_rate(oracle: address): u64 acquires Oracle {
        borrow_global<Oracle>(oracle).exchange_rate
    }

    public entry fun set_exchange_rate(oracle: &signer, new_rate: u64) acquires Oracle {
        let o = borrow_global_mut<Oracle>(signer::address_of(oracle));
        o.exchange_rate = new_rate;
    }

    #[test_only]
    public fun test_init_module(oracle : &signer) {
        init_module(oracle);
    }
}