import credits.aleo;
// The 'piggybanker' program.
program piggybanker.aleo {

    const CREDITS_TOKEN_ID: field = 3443843282313283355522573239085696902919850365217539366784739393210722344986field;
    record Token {
        owner: address,
        amount: u128,
        token_id: field,
        external_authorization_required: bool,
        authorized_until: u32
    }
    record Vault {
        owner: address,
        amount: u128,
        token_id: field,
        start_time: u32,
        end_time: u32
    }
    mapping balance: address => u128;
    mapping deposist: address => u128;
    mapping vaultend: address => u32;
    mapping registered_tokens: field => TokenMetadata;
    mapping balances: field => Balance; // hash(token_id, account) => Balance
    mapping authorized_balances: field => Balance; // hash(token_id, account) => Balance
    mapping allowances: field => u128; // hash(token_id, account, spender) => Allowance

    const MINTER_ROLE: u8 = 1u8;
    const BURNER_ROLE: u8 = 2u8;
    const SUPPLY_MANAGER_ROLE: u8 = 3u8;
    mapping roles: field => u8; // hash(token_id, account) => role
    struct TokenMetadata {
        token_id: field,
        name: u128, // ASCII text represented in bits, and the u128 value of the bitstring
        symbol: u128, // ASCII text represented in bits, and the u128 value of the bitstring
        decimals: u8,
        supply: u128,
        max_supply: u128,
        admin: address,
        external_authorization_required: bool, // whether or not this token requires authorization from an external program before transferring
        external_authorization_party: address
    }
    struct TokenOwner {
        account: address,
        token_id: field
    }

    struct Balance {
        token_id: field,
        account: address,
        balance: u128,
        authorized_until: u32
    }

    struct Allowance {
        account: address,
        spender: address,
        token_id: field
    }
    

    async transition createvault() -> (Vault, Future) {
        let signer: address = self.signer;
        let create: Vault = Vault {
            owner: signer,
            amount: 0u128,
            token_id: CREDITS_TOKEN_ID,
            start_time: 0u32,
            end_time: 0u32
        };
        return (create, finalize_createvault(signer));
    }
    async function finalize_createvault( signer: address) {
        // Create a new vault for the depositor.
    
        return; //return the vault.
      //  Mapping::set(vaultend, signer, block.height + 3456u32);


    }
    async transition privitize(

    recipient: address,
    public amount: u128,
    public external_authorization_required: bool
  ) -> (Token, Future) {
    let authorized_until: u32 = external_authorization_required ? 0u32 : 4294967295u32;
    let token: Token = Token {
      owner: recipient,
      amount: amount,
      token_id: CREDITS_TOKEN_ID,
      external_authorization_required: external_authorization_required,
      authorized_until: authorized_until
    };

    let sender_key: TokenOwner = TokenOwner {
      account: self.caller,
      token_id: CREDITS_TOKEN_ID
    };
    let sender_key_hash: field = BHP256::hash_to_field(sender_key);
    return (token, finalize_privatize(CREDITS_TOKEN_ID, amount, self.signer, external_authorization_required, sender_key_hash));
  }

  async function finalize_privatize(
    token_id: field,
    amount: u128,
    owner: address,
    external_authorization_required: bool,
    sender_key_hash: field
  ) {
    // Check that the transfer record's authorization matches the token's external_authorization_required
    let token: TokenMetadata = registered_tokens.get(token_id);
    assert_eq(token.external_authorization_required, external_authorization_required);

    // Get stored balances for the owner
    let owner_balance: Balance = authorized_balances.get(sender_key_hash);
    // Assert that the balance authorization is not expired or that the token does not require authorization
    let token_metadata: TokenMetadata = registered_tokens.get(token_id);
    assert(block.height <= owner_balance.authorized_until || !token_metadata.external_authorization_required);
    // Update the balance
    let new_balance: Balance = Balance {
      token_id: token_id,
      account: owner,
      balance: owner_balance.balance - amount,
      authorized_until: owner_balance.authorized_until
    };
    authorized_balances.set(sender_key_hash, new_balance);
  }

    // Deposits some amount of money into the bank.
    // Returns a new Token with the remaining amount of money.
    // - `token` : A record containing tokens to deposit.
    // - `amount`: The amount of tokens to deposit.
    async transition deposit(token: Token, create: Vault, amount: u128) -> ( Token, Vault, Future) {
        

        // Get the vault of the sender.
        let owner_tokens: u128 = token.amount;
        let reciept: Token = Token {
            owner: token.owner,
            amount: amount,
            token_id: CREDITS_TOKEN_ID,
            external_authorization_required: token.external_authorization_required,
            authorized_until: token.authorized_until
        };
        let ovault: Vault = Vault {
            owner: create.owner,
            amount: taxed_amount,
            token_id: create.token_id,
            start_time: create.start_time,
            end_time: create.end_time

        };
        let sender: address = self.signer;
        assert_eq(true, sender == create.owner);
        // Compute the hash of the token owner.
        return (reciept, ovault,  finalize_deposit(sender, amount));
    }

    // Updates on-chain state by the amount of tokens deposited.
    // - `hash`  : The hash of the token owner.
    // - `amount`: The amount of tokens that were deposited.
    async function finalize_deposit(sender: address, amount: u128)  {


        let sender_old_balance: u128 = balance.get_or_use(sender, 0u128);
        let sender_new_balance: u128 = sender_old_balance - amount;
        balance.set(sender, sender_new_balance);
    }
    async transition withdraw(amount: u128) -> ( Future) {
      

        return  finalize_withdraw(self.signer, amount);
    }
    async function finalize_withdraw(owner: address, amount: u128) {
        let vault_amount: u128 = Mapping::get(deposist, owner);
        assert_eq(true, vault_amount > 0u128);
        Mapping::set(deposist, owner, vault_amount - amount);
        let current_amount: u128 = Mapping::get_or_use(balance, owner, 0u128);
        Mapping::set(balance, owner, current_amount + amount);
    }


}
