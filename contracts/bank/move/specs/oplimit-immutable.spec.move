spec bank_addr::bank {
     spec module {
	  invariant update [global] forall a: address where old(exists<Bank>(a)): 
	  	  global<Bank>(a).opLimit == old(global<Bank>(a).opLimit);
    }
 }
