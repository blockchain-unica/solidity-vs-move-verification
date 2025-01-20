spec bank_addr::bank {
     spec module {

	  invariant forall a: address where exists<Bank>(a):
	  	  global<Bank>(a).owner == a;
		  
	  invariant update [global] forall a: address where old(exists<Bank>(a) ): 
	  	  global<Bank>(a).owner == old(global<Bank>(a).owner);
    }
 }
