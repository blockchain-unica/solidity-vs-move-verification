module oracle_addr::oracle {
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

    public entry fun set_exchange_rate(oracle: address, new_rate: u64) acquires Oracle {
        let o = borrow_global_mut<Oracle>(oracle);
        o.exchange_rate = new_rate;
    }
}