import credits.aleo;
program piggybanker.aleo;

record Token:
    owner as address.private;
    amount as u64.private;

mapping balances:
    key as address.public;
    value as u64.public;

function deposit:
    input r0 as address.private;
    input r1 as u64.private;
    cast self.caller r1 into r2 as Token.record;
    async deposit self.caller r1 into r3;
    output r2 as Token.record;
    output r3 as piggybanker.aleo/deposit.future;

finalize deposit:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use balances[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into balances[r0];

function withdraw:
    input r0 as address.private;
    input r1 as u64.private;
    assert.eq self.caller aleo1rhgdu77hgyqd3xjj8ucu3jj9r2krwz6mnzyd80gncr5fxcwlh5rsvzp9px;
    cast self.caller r1 into r2 as Token.record;
    async withdraw self.caller r1 into r3;
    output r2 as Token.record;
    output r3 as piggybanker.aleo/withdraw.future;

finalize withdraw:
    input r0 as address.public;
    input r1 as u64.public;
    get.or_use balances[r0] 0u64 into r2;
    sub r2 r1 into r3;
    set r3 into balances[r0];
