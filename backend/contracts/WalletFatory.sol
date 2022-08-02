// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

import './MultisigWallet.sol';

// Ownerごとに新しくMultisigWalletを作成するため、ownerからの呼び出しはFactoryContractで受ける
contract WalletFactory {
    // MultiSigWallet型の配列
    MultisigWallet[] public wallets;    

    // Walletインスタンス生成用のイベント
    event WalletCreated (MultisigWallet indexed wallet, string name, address[] owners, uint required);

    // MultisigWalletのインスタンス生成メソッド
    function createWallet (
        string memory _name,
        address[] memory _owners,
        uint _required
    ) public {
        //MultisigWallet wallet = new MultisigWallet(_name, _owners, _required);
    }
}
