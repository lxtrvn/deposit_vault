import credits.aleo;
// The 'piggybanker' program.
program piggybanker.aleo {
    const ADMIN: address = aleo1f6hhrs823257c4p8efy26cwp4fwga4wjl2s0383e52ngw3xhnq9q2dlwl7;
    const TAX: u16 = 93u16;
    record Token {
        owner: address,
        amount: u64
    }
    
    mapping balances: address => u64;


     // Deposits some amount of money into the bank.
    // Returns a new Token with the remaining amount of money.
    // - `token` : A record containing tokens to deposit.
    // - `amount`: The amount of tokens to deposit.
    async transition deposit(sender: address, amount: u64) -> (Token, Future) {
        

        let vault: Token = Token {
            owner: self.caller,
            amount: amount,
        };
        
        // Compute the hash of the token owner.
        return (vault, finalize_deposit(self.caller, amount));
    }

    // Updates on-chain state by the amount of tokens deposited.
    // - `hash`  : The hash of the token owner.
    // - `amount`: The amount of tokens that were deposited.
    async function finalize_deposit(owner: address, amount: u64) {
        let current_amount: u64 = Mapping::get_or_use(balances, owner, 0u64);
        Mapping::set(balances, owner, current_amount + amount);
    }
    
    async transition withdraw(sender: address, amount: u64) -> (Token, Future) {
        assert_eq(self.caller, aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px);


        let vault: Token = Token {
            owner: self.caller,
            amount: amount,
        };

        return (vault, finalize_withdraw(self.caller, amount));
    }
    async function finalize_withdraw(owner: address, amount: u64) {
        let current_amount: u64 = Mapping::get_or_use(balances, owner, 0u64);
        Mapping::set(balances, owner, current_amount - amount);
    }


}