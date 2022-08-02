// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

// Ownerごとに新しくMultisigWalletを作成するため、ownerからの呼び出しはFactoryContractで受ける
contract WalletFactory {
    // MultiSigWallet型の配列
    MultiSigWallet[] public wallets;    
}
