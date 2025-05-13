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

export default function Providers({ children }) {
  const wallets = useMemo(
    () => [
      new LeoWalletAdapter({
        appName: 'Aleo app',
      }),
      new PuzzleWalletAdapter({
        programIdPermissions: {
          [WalletAdapterNetwork.MainnetBeta]: ['dApp_1.aleo', 'dApp_1_import.aleo', 'dApp_1_import_2.aleo'],
          [WalletAdapterNetwork.TestnetBeta]: ['dApp_1_test.aleo', 'dApp_1_test_import.aleo', 'dApp_1_test_import_2.aleo']
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
    <WalletProvider
      wallets={wallets}
      decryptPermission={DecryptPermission.UponRequest}
      network={WalletAdapterNetwork.MainnetBeta}
      autoConnect
    >
      <WalletModalProvider>
        {children}
      </WalletModalProvider>
    </WalletProvider>
  );
}