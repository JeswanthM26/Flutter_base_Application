// // import 'dart:convert';

// // DepositResponse depositResponseFromJson(String str) =>
// //     DepositResponse.fromJson(json.decode(str));

// // class DepositResponse {
// //   final List<Deposit> deposits;

// //   DepositResponse({required this.deposits});

// //   factory DepositResponse.fromJson(Map<String, dynamic> json) {
// //     var depositsList = json['APZRMB__DepositDetails_Res']['apiResponse']
// //         ['ResponseBody']['responseObj']['deposits'] as List;
// //     List<Deposit> deposits =
// //         depositsList.map((i) => Deposit.fromJson(i)).toList();
// //     return DepositResponse(deposits: deposits);
// //   }
// // }

// // class Deposit {
// //   final String customerId;
// //   final String customerName;
// //   final String accountNo;
// //   final String accountType;
// //   final String currency;
// //   final String availableBalance;
// //   final String currentBalance;

// //   Deposit({
// //     required this.customerId,
// //     required this.customerName,
// //     required this.accountNo,
// //     required this.accountType,
// //     required this.currency,
// //     required this.availableBalance,
// //     required this.currentBalance,
// //   });

// //   factory Deposit.fromJson(Map<String, dynamic> json) {
// //     return Deposit(
// //       customerId: json['customerId'],
// //       customerName: json['customerName'],
// //       accountNo: json['accountNo'],
// //       accountType: json['accountType'],
// //       currency: json['currency'],
// //       availableBalance: json['availableBalance'],
// //       currentBalance: json['currentBalance'],
// //     );
// //   }
// // }

// import 'dart:convert';

// DepositAccount depositAccountFromJson(String str) =>
//     DepositAccount.fromJson(json.decode(str));

// class DepositAccount {
//   final String accountNo;
//   final String accOpenDate;
//   final String currency;
//   final String depositAmount;
//   final String interestAmount;
//   final String interestRate;
//   final String maturityDate;

//   DepositAccount({
//     required this.accountNo,
//     required this.accOpenDate,
//     required this.currency,
//     required this.depositAmount,
//     required this.interestAmount,
//     required this.interestRate,
//     required this.maturityDate,
//   });

//   factory DepositAccount.fromJson(Map<String, dynamic> json) {
//     final accountData =
//         json['apiResponse']['ResponseBody']['responseObj']['accounts'];
//     return DepositAccount(
//       accountNo: accountData['accountNo'],
//       accOpenDate: accountData['accOpenDate'],
//       currency: accountData['currency'],
//       depositAmount: accountData['depositAmount'],
//       interestAmount: accountData['interestAmount'],
//       interestRate: accountData['interestRate'],
//       maturityDate: accountData['maturityDate'],
//     );
//   }
// }
import 'dart:convert';

DepositAccountResponse depositAccountResponseFromJson(String str) =>
    DepositAccountResponse.fromJson(json.decode(str));

class DepositAccountResponse {
  final List<DepositAccount> accounts;

  DepositAccountResponse({required this.accounts});

  factory DepositAccountResponse.fromJson(Map<String, dynamic> json) {
    var accountsList = json['apiResponse']['ResponseBody']['responseObj']['accounts'] as List;
    List<DepositAccount> accounts =
        accountsList.map((i) => DepositAccount.fromJson(i)).toList();
    return DepositAccountResponse(accounts: accounts);
  }
}

class DepositAccount {
  final String accountNo;
  final String accOpenDate;
  final String currency;
  final String depositAmount;
  final String interestAmount;
  final String interestRate;
  final String maturityDate;

  DepositAccount({
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
      maturityDate: json['maturityDate'],
    );
  }
}
