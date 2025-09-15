import 'dart:convert';

DepositAccountResponse depositAccountResponseFromJson(String str) =>
    DepositAccountResponse.fromJson(json.decode(str));

class DepositAccountResponse {
  final List<DepositAccount> accounts;

  DepositAccountResponse({required this.accounts});

  factory DepositAccountResponse.fromJson(Map<String, dynamic> json) {
    var accountsList = json['APZRMB__DepositDetails_Res']['apiResponse']
        ['ResponseBody']['responseObj']['accounts'] as List;
    List<DepositAccount> accounts =
        accountsList.map((i) => DepositAccount.fromJson(i)).toList();
    return DepositAccountResponse(accounts: accounts);
  }
}

class DepositAccount {
final String accountType;
  final String accountNo;
  final String accOpenDate;
  final String currency;
  final String depositAmount;
  final String interestAmount;
  final String interestRate;
  final String maturityDate;

  DepositAccount({
    required this.accountType,
    required this.accountNo,
    required this.accOpenDate,
    required this.currency,
    required this.depositAmount,
    required this.interestAmount,
    required this.interestRate,
    required this.maturityDate,
  });

  factory DepositAccount.fromJson(Map<String, dynamic> json) {
    return DepositAccount(
      accountNo: json['accountNo'],
      accOpenDate: json['accOpenDate'],
      currency: json['currency'],
      depositAmount: json['depositAmount'],
      interestAmount: json['interestAmount'],
      interestRate: json['interestRate'],
      accountType: json['accountType'],
      maturityDate: json['maturityDate'],
    );
  }
}
