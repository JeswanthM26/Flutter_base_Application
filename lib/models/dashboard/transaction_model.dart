class Transaction {
  final String txnRefNo;
  final String txnType;
  final String txnDate;
  final double txnAmount;
  final String txnCurrency;
  final String txnStatus;
  final String remarks;
  final String debitAccNo;
  final String beneAcctNo;
  final String? nickName;

  Transaction({
    required this.txnRefNo,
    required this.txnType,
    required this.txnDate,
    required this.txnAmount,
    required this.txnCurrency,
    required this.txnStatus,
    required this.remarks,
    required this.debitAccNo,
    required this.beneAcctNo,
    this.nickName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      txnRefNo: json["txnRefNo"],
      txnType: json["txnType"],
      txnDate: json["txnDate"],
      txnAmount: (json["txnAmount"] as num).toDouble(),
      txnCurrency: json["txnCurrency"],
      txnStatus: json["txnStatus"],
      remarks: json["remarks"],
      debitAccNo: json["debitAccNo"],
      beneAcctNo: json["beneAcctNo"],
      nickName: json["nickName"],
    );
  }

  static List<Transaction> listFromApi(Map<String, dynamic> json) {
    final List<dynamic> list =
        json["apiResponse"]["ResponseBody"]["responseObj"];
    return list.map((e) => Transaction.fromJson(e)).toList();
  }
}
