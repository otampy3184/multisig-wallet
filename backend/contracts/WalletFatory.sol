// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

import './MultisigWallet.sol';

// Ownerごとに新しくMultisigWalletを作成するため、ownerからの呼び出しはFactoryContractで受ける
contract WalletFactory {
    // MultiSigWallet型の配列
    MultisigWallet[] public wallets;  

    uint256 constant maxLimit = 20;  

    // Walletインスタンス生成用のイベント
    event WalletCreated (MultisigWallet indexed wallet, string name, address[] owners, uint required);

    function walletsCount() public view returns (uint256) {
        return wallets.length;
    }

    // MultisigWalletのインスタンス生成メソッド
    function createWallet (
        string memory _name,
        address[] memory _owners,
        uint _required
    ) public {
        MultisigWallet wallet = new MultisigWallet(_name, _owners, _required);
        wallets.push(wallet);
        emit WalletCreated(wallet, _name, _owners, _required);
    }

    function getWallets(uint limit, uint256 offset) public view returns (MultisigWallet[] memory coll) {
        require(offset <= walletsCount(), "offset out of bounds");
        uint256 size = walletsCount() - offset;
        size = size < limit ? size : limit;
        size = size < maxLimit ? size : maxLimit;
        coll = new MultisigWallet[](size);

        for ( uint256 i = 0; i < size; i++){
            coll[i] = wallets[offset + i];
        }

        return coll;
    }
}
