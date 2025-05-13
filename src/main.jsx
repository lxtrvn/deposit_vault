import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { WalletModalProvider } from "@demox-labs/aleo-wallet-adapter-reactui";
import { WalletProvider } from "@demox-labs/aleo-wallet-adapter-react";
import { DecryptPermission, WalletAdapterNetwork } from "@demox-labs/aleo-wallet-adapter-base";
import { useMemo } from "react";
import { 
  PuzzleWalletAdapter, 
  LeoWalletAdapter, 
  FoxWalletAdapter,
  SoterWalletAdapter 
} from 'aleo-adapters';

const Root = () => {
  const wallets = useMemo(
    () => [
      new LeoWalletAdapter({
        appName: 'Aleo app',
      }),
      new PuzzleWalletAdapter({
        programIdPermissions: {
          [WalletAdapterNetwork.TestnetBeta]: ['token_registry.aleo']
        },
        appName: 'Aleo app',
        appDescription: 'A privacy-focused DeFi app',
        appIconUrl: ''
      }),
      new FoxWalletAdapter({
        appName: 'Aleo app',
      }),
      new SoterWalletAdapter({
        appName: 'Aleo app',
      })
    ],
    []
  );

  return (
    <React.StrictMode>
      <WalletProvider
        wallets={wallets}
        network={WalletAdapterNetwork.TestnetBeta}
        decryptPermission={DecryptPermission.UponRequest}
        autoConnect
      >
        <WalletModalProvider>
          <App />
        </WalletModalProvider>
      </WalletProvider>
    </React.StrictMode>
  );
};
