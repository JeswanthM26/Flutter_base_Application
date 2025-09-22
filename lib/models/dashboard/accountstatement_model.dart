class AccountStatementModel {
  final String accountNo;
  final List<TransactionTrendModel> trend;

  AccountStatementModel({
    required this.accountNo,
    required this.trend,
  });

  factory AccountStatementModel.fromJson(Map<String, dynamic> json) {
    return AccountStatementModel(
      accountNo: json['accountNo'] ?? '',
      trend: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => TransactionTrendModel.fromJson(e))
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
      date: json['date'] ?? '',
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0,
      accountCcy: json['accountCcy'] ?? '',
      accountNo: json['accountNo'] ?? '',
      openingBalance: double.tryParse(json['openingBalance']?.toString() ?? '0') ?? 0,
      closingBalance: double.tryParse(json['closingBalance']?.toString() ?? '0') ?? 0,
      runningBalance: double.tryParse(json['runningBalance']?.toString() ?? '0') ?? 0,
      creditAccount: json['creditAccount'] ?? '',
      creditAccountCcy: json['creditAccountCcy'] ?? '',
      debAccountCcy: json['debAccountCcy'] ?? '',
      drcrIndicator: json['drcrIndicator'] ?? '',
      trnAmount: double.tryParse(json['trnAmount']?.toString() ?? '0') ?? 0,
      trnCcy: json['trnCcy'] ?? '',
      currencyIcon: json['currencyIcon'] ?? '',
      transactionCcyIcon: json['transactionCcyIcon'] ?? '',
      trnDate: json['trnDate'] ?? '',
      trnDesc: json['trnDesc'] ?? '',
      trnRefNo: json['trnRefNo'] ?? '',
      customerId: json['customerId'] ?? '',
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
}
