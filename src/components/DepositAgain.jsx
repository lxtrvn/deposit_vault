import React, { useState } from 'react';
import { useProgramManager } from '@aleohq/sdk';

const DepositAgain = () => {
    const [vaultRecord, setVaultRecord] = useState('');
    const [creditsRecord, setCreditsRecord] = useState('');
    const [amount, setAmount] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const { executeFunction } = useProgramManager();

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            setLoading(true);
            const result = await executeFunction('piggybanker.aleo', 'deposit_again', [vaultRecord, creditsRecord, amount]);
            console.log(result);
            setError(null);
        } catch (error) {
            setError(error.message);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div>
            <h2>Deposit Again</h2>
            {error && <p style={{ color: 'red' }}>{error}</p>}
            <form onSubmit={handleSubmit}>
                <input
                    type="text"
                    value={vaultRecord}
                    onChange={(e) => setVaultRecord(e.target.value)}
                    placeholder="Vault Record"
                    required
                />
                <input
                    type="text"
                    value={creditsRecord}
                    onChange={(e) => setCreditsRecord(e.target.value)}
                    placeholder="Credits Record"
                    required
                />
                <input
                    type="number"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    placeholder="Amount"
                    required
                />
                <button type="submit" disabled={loading}>
                    Deposit Again
                </button>
            </form>
        </div>
    );
};

export default DepositAgain;
