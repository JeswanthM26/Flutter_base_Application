class AccountModel {
  final String customerId;
  final String customerName;
  final String accountNo;
  final String accountType;
  final String loanType;
  final String currency;
  final String availableBalance;
  final String availBalanceFcy;
  final String? nickName;
  final String? creditAllowed;
  final String? debitAllowed;
  final String? acctName;
  final String showHideAccounts;

  AccountModel({
    required this.customerId,
    required this.customerName,
    required this.accountNo,
    required this.accountType,
    required this.loanType,
    required this.currency,
    required this.availableBalance,
    required this.availBalanceFcy,
    this.nickName,
    this.creditAllowed,
    this.debitAllowed,
    this.acctName,
    required this.showHideAccounts,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      accountNo: json['accountNo'] ?? '',
      accountType: json['accountType'] ?? '',
      loanType: json['loanType'] ?? '',
      currency: json['currency'] ?? '',
      availableBalance: json['availableBalance'] ?? '',
      availBalanceFcy: json['availBalanceFcy'] ?? '',
      nickName: json['nickName'],
      creditAllowed: json['creditAllowed'],
      debitAllowed: json['debitAllowed'],
      acctName: json['acctName'],
      showHideAccounts: json['showHideAccounts'] ?? '',
    );
  }
}
