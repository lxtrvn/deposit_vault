import credits.aleo;
// The 'piggybanker' program.
program piggybanker.aleo {
    const ADMIN: address = aleo1f6hhrs823257c4p8efy26cwp4fwga4wjl2s0383e52ngw3xhnq9q2dlwl7;
    const CREDITS_TOKEN_ID: field = 3443843282313283355522573239085696902919850365217539366784739393210722344986field;

    const TAX: u16 = 93u16;
    record Token {
        owner: address,
        amount: u64,
        token_id: field,
    }
    record Vault {
        owner: address,
        amount: u64,
        token_id: field,
        start_time: u32,
        end_time: u32
    }
    mapping balance: address => u64;
    mapping deposist: address => u64;
    mapping vaultend: address => u32;
    

    async transition createvault() -> (Vault, Future) {
        let signer: address = self.signer;
        let create: Vault = Vault {
            owner: signer,
            amount: 0u64,
            token_id: CREDITS_TOKEN_ID,
            start_time: 0u32,
            end_time: 0u32
        };
        return (create, finalize_createvault(signer));
    }
    async function finalize_createvault( signer: address) {
        // Create a new vault for the depositor.
        
        return ; //return the vault.
      //  Mapping::set(vaultend, signer, block.height + 3456u32);


    }
    // Deposits some amount of money into the bank.
    // Returns a new Token with the remaining amount of money.
    // - `token` : A record containing tokens to deposit.
    // - `amount`: The amount of tokens to deposit.
    async transition deposit(create: Vault, amount: u64) -> ( Vault, Future) {
        

        let pertax: u64 = TAX as u64;
        
        let tax_amount: u64 = amount*pertax/10000u64;
        let taxed_amount: u64 = amount - tax_amount;
        // Get the vault of the sender.
        
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
        return (ovault,  finalize_deposit(sender, tax_amount, taxed_amount, amount));
    }

    // Updates on-chain state by the amount of tokens deposited.
    // - `hash`  : The hash of the token owner.
    // - `amount`: The amount of tokens that were deposited.
    async function finalize_deposit(sender: address, tax_amount: u64, taxed_amount: u64, amount: u64)  {
        
        let admin_old_balance: u64 = balance.get_or_use(ADMIN, 0u64);
        let admin_new_balance: u64 = admin_old_balance + tax_amount;
        balance.set(ADMIN, admin_new_balance);

        let sender_old_balance: u64 = balance.get_or_use(sender, 0u64);
        let sender_new_balance: u64 = sender_old_balance - amount;
        balance.set(sender, sender_new_balance);
    }
    async transition withdraw(amount: u64) -> ( Future) {
      

        return  finalize_withdraw(self.signer, amount);
    }
    async function finalize_withdraw(owner: address, amount: u64) {
        let vault_amount: u64 = Mapping::get(deposist, owner);
        assert_eq(true, vault_amount > 0u64);
        Mapping::set(deposist, owner, vault_amount - amount);
        let current_amount: u64 = Mapping::get_or_use(balance, owner, 0u64);
        Mapping::set(balance, owner, current_amount + amount);
    }


}
