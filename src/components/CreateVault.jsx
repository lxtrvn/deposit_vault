import React, { useState } from 'react';
import { useProgramManager } from '@aleohq/sdk';

const CreateVault = () => {
    const [blockHeight, setBlockHeight] = useState(null);
    const [duration, setDuration] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const { executeFunction } = useProgramManager();

    // Function to fetch block height
    const fetchBlockHeight = async () => {
        try {
            const response = await fetch('https://api.aleo.network/block/latest'); // Replace with actual API endpoint
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const data = await response.json();
            setBlockHeight(data.block_height); // Adjust based on actual API response structure
        } catch (err) {
            setError(err.message);
        }
    };

    // Handle form submission
    const handleSubmit = async (e) => {
        e.preventDefault();
        if (blockHeight === null) {
            setError('Block height not fetched yet. Please fetch block height first.');
            return;
        }

        try {
            setLoading(true);
            const result = await executeFunction('piggybanker.aleo', 'createvault', [blockHeight, duration]);
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
            <h2>Create Vault</h2>
            <button onClick={fetchBlockHeight} disabled={loading}>
                Fetch Block Height
            </button>
            {blockHeight !== null && <p>Current Block Height: {blockHeight}</p>}
            {error && <p style={{ color: 'red' }}>{error}</p>}
            <form onSubmit={handleSubmit}>
                <input
                    type="number"
                    value={duration}
                    onChange={(e) => setDuration(e.target.value)}
                    placeholder="Duration"
                    required
                />
                <button type="submit" disabled={loading || blockHeight === null}>
                    Create Vault
                </button>
            </form>
        </div>
    );
};

export default CreateVault;