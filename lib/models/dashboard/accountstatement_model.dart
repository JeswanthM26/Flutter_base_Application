class AccountStatementModel {
  final String accountNo;
  final List<TransactionTrendModel> trend;
 
  AccountStatementModel({
    required this.accountNo,
    required this.trend,
  });
 
  factory AccountStatementModel.fromJson(Map<String, dynamic> json) {
    return AccountStatementModel(
      accountNo: json['accountNo']?.toString() ?? '',
      trend: (json['transactions'] as List<dynamic>? ?? [])
          .where((e) => e != null)
          .map((e) => TransactionTrendModel.fromJson(e!))
          .toList(),
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'accountNo': accountNo,
      'transactions': trend.map((e) => e.toJson()).toList(),
    };
  }
}
 
class TransactionTrendModel {
  final String date;
  final double balance;
  final String accountCcy;
  final String accountNo;
  final double openingBalance;
  final double closingBalance;
  final double runningBalance;
  final String creditAccount;
  final String creditAccountCcy;
  final String debAccountCcy;
  final String drcrIndicator;
  final double trnAmount;
  final String trnCcy;
  final String currencyIcon;
  final String transactionCcyIcon;
  final String trnDate;
  final String trnDesc;
  final String trnRefNo;
  final String customerId;
 
  TransactionTrendModel({
    required this.date,
    required this.balance,
    required this.accountCcy,
    required this.accountNo,
    required this.openingBalance,
    required this.closingBalance,
    required this.runningBalance,
    required this.creditAccount,
    required this.creditAccountCcy,
    required this.debAccountCcy,
    required this.drcrIndicator,
    required this.trnAmount,
    required this.trnCcy,
    required this.currencyIcon,
    required this.transactionCcyIcon,
    required this.trnDate,
    required this.trnDesc,
    required this.trnRefNo,
    required this.customerId,
  });
 
  factory TransactionTrendModel.fromJson(Map<String, dynamic> json) {
    return TransactionTrendModel(
      date: json['date']?.toString() ?? '',
      balance: _toDouble(json['balance']),
      accountCcy: json['accountCcy']?.toString() ?? '',
      accountNo: json['accountNo']?.toString() ?? '',
      openingBalance: _toDouble(json['openingBalance']),
      closingBalance: _toDouble(json['closingBalance']),
      runningBalance: _toDouble(json['runningBalance']),
      creditAccount: json['creditAccount']?.toString() ?? '',
      creditAccountCcy: json['creditAccountCcy']?.toString() ?? '',
      debAccountCcy: json['debAccountCcy']?.toString() ?? '',
      drcrIndicator: json['drcrIndicator']?.toString() ?? '',
      trnAmount: _toDouble(json['trnAmount']),
      trnCcy: json['trnCcy']?.toString() ?? '',
      currencyIcon: json['currencyIcon']?.toString() ?? '',
      transactionCcyIcon: json['transactionCcyIcon']?.toString() ?? '',
      trnDate: json['trnDate']?.toString() ?? '',
      trnDesc: json['trnDesc']?.toString() ?? '',
      trnRefNo: json['trnRefNo']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'balance': balance.toStringAsFixed(2),
      'accountCcy': accountCcy,
      'accountNo': accountNo,
      'openingBalance': openingBalance.toStringAsFixed(2),
      'closingBalance': closingBalance.toStringAsFixed(2),
      'runningBalance': runningBalance.toStringAsFixed(2),
      'creditAccount': creditAccount,
      'creditAccountCcy': creditAccountCcy,
      'debAccountCcy': debAccountCcy,
      'drcrIndicator': drcrIndicator,
      'trnAmount': trnAmount.toStringAsFixed(2),
      'trnCcy': trnCcy,
      'currencyIcon': currencyIcon,
      'transactionCcyIcon': transactionCcyIcon,
      'trnDate': trnDate,
      'trnDesc': trnDesc,
      'trnRefNo': trnRefNo,
      'customerId': customerId,
    };
  }
 
  // Helper to safely parse numbers
  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0;
  }
}
 
 