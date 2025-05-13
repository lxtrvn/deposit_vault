import credits.aleo;
// The 'piggybanker' program.
program piggybanker.aleo {
    const CREDITS_TOKEN_ID: field = 3443843282313283355522573239085696902919850365217539366784739393210722344986field;
    record Token {
        owner: address,
        amount: u128,
        token_id: field
    }
    record Vault {
        owner: address,
        amount: u128,
        token_id: field,
        start_time: u32,
        end_time: u32
    }
    mapping balance: address => u128;

    async transition createvault(height: u32, minutes: u32 ) -> (Vault, Future) {
        let duration: u32 =minutes * 12u32;
        let signer: address = self.signer;
        let create: Vault = Vault {
            owner: signer,
            amount: 0u128,
            token_id: CREDITS_TOKEN_ID,
            start_time: height,
            end_time: height + duration 
        };
        return (create, finalize_createvault(height));
    }
    async function finalize_createvault( height: u32) {
        // Check innput against current block height
        assert_eq(true, block.height-height < 144u32);
        return; //return the vault.
    }

    async transition privatize(
    recipient: address,
    public amount: u128
  ) -> (Token, Future) {
    let token: Token = Token {
      owner: self.signer,
      amount: amount,
      token_id: CREDITS_TOKEN_ID
    };
    return (token, finalize_privatize(CREDITS_TOKEN_ID, amount, self.signer));
  }
  async function finalize_privatize(
    token_id: field,
    amount: u128,
    owner: address
  ) {
    // Get stored balances for the owner
    let owner_balance: u128 = Mapping::get_or_use(balance, owner, 0u128);
    // Check that the owner has enough balance    
    assert_eq(true, owner_balance >= amount);
    // Update the owner's balance
    let new_balance: u128 = owner_balance - amount;
    balance.set(owner, new_balance);
    // Check that the token ID is valid     
    assert_eq(token_id,CREDITS_TOKEN_ID);
    // Check that the amount is valid
    assert_eq(true, amount > 0u128);
  }
    // Deposits some amount of money into the bank.
    // Returns a new Token with the remaining amount of money.
    // - `token` : A record containing tokens to deposit.
    // - `amount`: The amount of tokens to deposit.
    async transition deposit_again(create: Vault, token: Token,  amount: u128) -> ( Vault, Token,  Future) {
        // Get the vault of the sender.
        let owner_tokens: u128 = token.amount;
        let ovault: Vault = Vault {
            owner: create.owner,
            amount: create.amount + amount,
            token_id: create.token_id,
            start_time: create.start_time,
            end_time: create.end_time
        };
        let reciept: Token = Token {
            owner: token.owner,
            amount: token.amount - amount,
            token_id: CREDITS_TOKEN_ID
        };
        let sender: address = self.signer;
        assert_eq(sender, create.owner);
        // Compute the hash of the token owner.
        return ( ovault, reciept,  finalize_deposit_again(sender, amount));
      }
      // - `hash`  : The hash of the token owner.
      // - `amount`: The amount of tokens that were deposited.
      async function finalize_deposit_again(sender: address, amount: u128)  {
        let sender_old_balance: u128 = balance.get_or_use(sender, 0u128);
        assert_eq(true, amount > 0u128);
        // Get stored balances for the sender
        // Check that the sender has enough balance
        assert_eq(true, amount <= sender_old_balance);
        let sender_new_balance: u128 = sender_old_balance - amount;
        balance.set(sender, sender_new_balance);
    }
    async transition withdraw(ovault: Vault,  amount: u128) -> (Vault, Future) {
      let vaultbalance: u128 = ovault.amount;
      assert_eq(true, vaultbalance > 0u128);
      assert_eq(true, amount <= vaultbalance);
      let endtime: u32 = ovault.end_time;
      let ready: Vault = Vault {
        owner: ovault.owner,
        amount: ovault.amount - amount,
        token_id: ovault.token_id,
        start_time: ovault.start_time,    
        end_time: ovault.end_time
      };
        return  ( ready, finalize_withdraw(self.signer, amount, endtime));
    }
    async function finalize_withdraw(owner: address, amount: u128,  endtime: u32) {
        // Get the vault of the sender.
        assert_eq(true, block.height > endtime);
        let pubbalance: u128 = balance.get_or_use(owner, 0u128);
        let newbalance: u128 = pubbalance + amount;
        balance.set(owner, newbalance);    
    }
}
