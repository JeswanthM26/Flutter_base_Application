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
  final String loanType;
  final String customerId;
  final String loanType;
  final String customerName;
  final String accountNo;
  final String accountType;
  final String currency;
  final String currentBalance;
<<<<<<< HEAD
  final  String availableBalance;
=======
  final String availableBalance;
  final String? interestRate;
>>>>>>> 8640d825809d5f522af9a57075ec5fb5feeff189

  Loan({
     required this.loanType,
    required this.customerId,
    required this.loanType,
    required this.customerName,
    required this.availableBalance,
    required this.accountNo,
    required this.accountType,
    required this.currency,
    required this.currentBalance,
    required this.availableBalance,
    this.interestRate,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      customerId: json['customerId'],
      loanType: json['loanType'],
      customerName: json['customerName'],
      accountNo: json['accountNo'],
      accountType: json['accountType'],
      currency: json['currency'],
      loanType: json['loanType'],
      availableBalance: json['availableBalance'],
      currentBalance: json['currentBalance'],
      availableBalance: json['availableBalance'],
      interestRate: json['interestRate'],
    );
  }
}
