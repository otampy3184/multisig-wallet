// SPDX-License-Identifier: unlicensed
pragma solidity ^0.8.0;

// Walletそのものを作るコントラクト
contract MultisigWallet {
  // トランザクションデータ用の構造体を定義
  struct Transaction {
    // 送信先のアドレス
    address to;
    // 送金額
    uint value;
    // トランザクションのバイトデータ
    bytes data;
    // 実行済みのフラグ
    bool executed;
  }
}
