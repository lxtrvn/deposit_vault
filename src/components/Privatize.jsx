// src/components/Privatize.js
import React, { useState } from 'react';
import { useProgramManager } from '@aleohq/sdk';

const Privatize = () => {
    const [amount, setAmount] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const { executeFunction } = useProgramManager();

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            setLoading(true);
            const result = await executeFunction('piggybanker.aleo', 'privatize', [amount]);
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
            <h2>Privatize</h2>
            {error && <p style={{ color: 'red' }}>{error}</p>}
            <form onSubmit={handleSubmit}>
                <input
                    type="number"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    placeholder="Amount"
                    required
                />
                <button type="submit" disabled={loading}>
                    Privatize
                </button>
            </form>
        </div>
    );
};

export default Privatize;