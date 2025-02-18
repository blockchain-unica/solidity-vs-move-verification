# Price Bet

The PriceBet contract allows a single player to place a bet against the contract owner. The bet is based on a future exchange rate between two tokens. 

To create the contract, the owner specifies:
- itself as the contract owner;
- the initial pot, which is transferred from the owner to the contract;
- an oracle, i.e a contract that is queried for the exchange rate between two given tokens;
- a deadline, i.e. a time limit after which the player loses the bet;
- a target exchange rate, which must be reached in order for the player to win the bet.

The contract has the following entry points:
- **join()**, which allows a player to join the bet. This requires the player to deposit an amount of native cryptocurrency equal to the initial pot;
- **win()**, which allows the joined player to withdraw the whole contract balance if the oracle exchange rate is greater than the bet rate. The player can call win() multiple times before the deadline. This action is disabled after the deadline;
- **timeout()**, which can be called by anyone after the deadline, and transfers the whole contract balance to the owner

## Implementations

- **Solidity**: [contract](certora/Pricebet.sol) | [properties](certora/)
- **Move**: [contract](move/sources/pricebet.move) | [properties](move/specs)

## Properties

- join-revert: 	a transaction `join()` reverts if the amount sent is different from initial_pot or another player has already joined

- join-not-revert:	a transaction `join()` does not revert if the amount sent is equal to initial_pot, no player has joined yet, and the sender has enough token

- <a name="win-revert">**win-revert**</a>:	a transaction `win()` reverts if the deadline has expired or the sender is not the player or the oracle exchange rate is smaller than the bet exchange rate

- win-not-revert:	a transaction `win()` does not revert if the deadline has not expired, the sender is the player, and the oracle exchange rate is greater or equal to the bet exchange rate. We assume that the oracle is reactive

- timeout-revert:	a transaction `timeout()` reverts if the deadline has not passed yet

-<a name="timeout-not-revert">**timeout-not-revert**</a>:	a transaction `timeout()` does not revert if the deadline has passed

- timeout-postcondition:	a successful `timeout()` transfers the whole contract balance to the owner

- only-owner-or-player-receive:	in any state after `join()`, only the owner or the player can receive tokens from the contract

- eventually-win:	eventually a user can withdraw the whole pot

- no-frozen-funds:	after the deadline, any user can perform some transaction that transfers the contract pot to the owner

- <a name="eventually-balance-zero">**eventually-balance-zero**</a>:	eventually the contract balance goes to 0 (assuming the fairness condition that timeout() is called at least once after the deadline)

- owner-cannot-withdraw-before-deadline:	if the deadline has not passed yet, the owner cannot withdraw the pot

- player-cannot-withdraw-after-deadline: if the deadline has passed yet, the player cannot withdraw the pot

- join-only-once: a `join()` transaction can only be called successfully once

- price-below-player-lose: if the price is always below the threshold before the deadline, the player cannot withdraw- 

- price-above-player-win:	if at some point before the deadline the price goes above the threshold, the player can withdraw

- winner-payout	the winner: receives at least twice the initial pot (assume that the oracle is not paid)
