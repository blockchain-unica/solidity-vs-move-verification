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

## Properties

