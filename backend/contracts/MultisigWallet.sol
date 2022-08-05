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

  // マルチシグウォレットの名前とそれを返すメソッド
  string public walletName;

  function getName() public view returns (string memory) {
    return walletName;
  }

  //Ownerアドレスを格納する配列とOwner数を返すメソッド
  address[] public owners;

  function getOwnersCount() public view returns(uint){
    return owners.length;
  }

  // ウォレットの閾値をいれる変数とそれを返すメソッド
  uint public required;

  function getRequired() public view returns(uint){
    return required;
  }

  //Transactionを入れる配列と、それを返すメソッド
  Transaction[] public transactions;

  function getTxs() public view returns(Transaction[] memory){
    return transactions;
  }


  // addressがowner権限を持っていたらTrueとするマッピング
  mapping(address => bool) public isOwner;

  // TransactionIDごとにOwner権限を管理するマッピング
  mapping(uint => mapping(address => bool)) public approved;

  // 各種イベント
  event Deposit(address indexed sender, uint amount);
  event Submit(uint indexed txId);
  event Approved(address indexed owner, uint indexed txId);
  event Revoke(address indexed owner, uint indexed txId);
  event Execute(uint indexed txId);

  // 各種modifier
  modifier onlyOwner() {
    require(isOwner[msg.sender], "sender must be owner");
    _;
  }

  modifier txExists(uint _txId) {
    require(_txId < transactions.length, "tx does not exist");
    _;
  }

  modifier notApproved(uint _txId) {
    require(!approved[_txId][msg.sender], "tx already approved");
    _;
  }

  modifier notExecuted(uint _txId) {
    require(!transactions[_txId].executed, "this tx is already exexuted");
    _;
  }


  /**
   * トランザクション提出用のメソッド
   * 提出するTransactionをTransactions[]の配列にPushし、ExecutedをFalseにする
   * @param _to 送金先のアドレス
   * @param _value　送金額
   * @param _data　バイトデータ
   */
  function submit(address _to, uint _value, bytes calldata _data) external onlyOwner{
    transactions.push(Transaction({
      to: _to,
      value: _value,
      data: _data,
      executed: false
    }));
    // 提出イベントを発行
    emit Submit(transactions.length - 1);
  }

  /**
   * 指定したIDのトランザクションを承認するメソッド
   * @param _txId 指定のトランザクションID
   */
  function approve(uint _txId)external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
    // 指定のtxについて、approvedのマッピングをtrueにする
    approved[_txId][msg.sender] = true;

    // 承認イベントを発行
    emit Approved(msg.sender, _txId);
  }
}
