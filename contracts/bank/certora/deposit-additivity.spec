// SPDX-License-Identifier: GPL-3.0-only
// certoraRun Bank_v1.sol:Bank --verify Bank:deposit-additivity.spec
// 

// two (successful) deposits of n1 and n2 units of T (performed by the same sender) are equivalent to a single deposit of n1+n2 units of T

rule deposit_additivity {
    env e1;
    env e2;
    env e3;

    storage initial = lastStorage;

    require e1.msg.sender == e2.msg.sender;

    deposit(e1);
    deposit(e2);

    storage s12 = lastStorage;

    require e3.msg.sender == e1.msg.sender;
    require e3.msg.value == e1.msg.value + e2.msg.value;

    deposit(e3) at initial;
    storage s3 = lastStorage;

    assert s12 == s3;
}
