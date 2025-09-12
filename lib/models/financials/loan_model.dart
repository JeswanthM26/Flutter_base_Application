import 'dart:convert';

LoanResponse loanResponseFromJson(String str) =>
    LoanResponse.fromJson(json.decode(str));

class LoanResponse {
  final List<Loan> loans;

  LoanResponse({required this.loans});

  factory LoanResponse.fromJson(Map<String, dynamic> json) {
    var loansList = json['APZRMB__LoanDetails_Res']['apiResponse']
        ['ResponseBody']['responseObj']['loans'] as List;
    List<Loan> loans = loansList.map((i) => Loan.fromJson(i)).toList();
    return LoanResponse(loans: loans);
  }
}

class Loan {
  final String customerId;
  final String customerName;
  final String accountNo;
  final String accountType;
  final String currency;
  final String currentBalance;

  Loan({
    required this.customerId,
    required this.customerName,
    required this.accountNo,
    required this.accountType,
    required this.currency,
    required this.currentBalance,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      customerId: json['customerId'],
      customerName: json['customerName'],
      accountNo: json['accountNo'],
      accountType: json['accountType'],
      currency: json['currency'],
      currentBalance: json['currentBalance'],
    );
  }
}
