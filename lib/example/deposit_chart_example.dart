
// // import 'package:Retail_Application/models/financials/deposit_model.dart' as dm;
// // import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';

// // class DepositsChartExample extends StatefulWidget {
// //   const DepositsChartExample({Key? key}) : super(key: key);

// //   @override
// //   _DepositsChartExampleState createState() => _DepositsChartExampleState();
// // }

// // class _DepositsChartExampleState extends State<DepositsChartExample> {
// //   dm.DepositAccountResponse? depositData;
// //   dm.DepositAccount? selectedAccount;
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //   }

// //   Future<void> _loadData() async {
// //     try {
// //       final depositJson =
// //           await rootBundle.loadString('mock/dashboard/deposits_mock.json');
// //       setState(() {
// //         depositData = dm.depositAccountResponseFromJson(depositJson);
// //         if (depositData != null && depositData!.accounts.isNotEmpty) {
// //           selectedAccount = depositData!.accounts.first;
// //         }
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       print('Error loading financial data: $e');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Deposits Donut Chart'),
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : SingleChildScrollView(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 children: [
// //                   if (depositData != null) _buildAccountDropdown(),
// //                   const SizedBox(height: 20),
// //                   if (selectedAccount != null) _buildDepositChart(),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildAccountDropdown() {
// //     return DropdownButton<dm.DepositAccount>(
// //       value: selectedAccount,
// //       isExpanded: true,
// //       items: depositData!.accounts.map((dm.DepositAccount account) {
// //         return DropdownMenuItem<dm.DepositAccount>(
// //           value: account,
// //           child: Text(account.accountNo),
// //         );
// //       }).toList(),
// //       onChanged: (dm.DepositAccount? newValue) {
// //         setState(() {
// //           selectedAccount = newValue;
// //         });
// //       },
// //     );
// //   }

// //   Widget _buildDepositChart() {
// //     final deposit = selectedAccount!;
// //     final principal = double.parse(deposit.depositAmount.replaceAll(',', ''));
// //     final interest = double.parse(deposit.interestAmount.replaceAll(',', ''));

// //     return HalfDonutChart(
// //       title: 'Deposits',
// //       centerText: 'Interest Rate',
// //       percentage: '${deposit.interestRate}%',
// //       sections: [
// //         DonutChartSectionDetails(
// //           value: principal,
// //           label: 'Deposited',
// //           amount: '${deposit.currency} ${deposit.depositAmount}',
// //           date: deposit.accOpenDate,
// //           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
// //         ),
// //         DonutChartSectionDetails(
// //           value: interest,
// //           label: 'Interest',
// //           amount: '${deposit.currency} ${deposit.interestAmount}',
// //           date: deposit.maturityDate,
// //           colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'package:Retail_Application/models/dashboard/account_model.dart';
// import 'package:Retail_Application/models/financials/deposit_model.dart' as dm;
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';

// class DepositsChartExample extends StatefulWidget {
//   const DepositsChartExample({Key? key}) : super(key: key);

//   @override
//   _DepositsChartExampleState createState() => _DepositsChartExampleState();
// }

// class _DepositsChartExampleState extends State<DepositsChartExample> {
//   AccountModel? depositData;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final depositJson =
//           await rootBundle.loadString('mock/dashboard/deposits_mock.json');
//       final decodedJson = json.decode(depositJson);
//       final accountData =
//           decodedJson['apiResponse']['ResponseBody']['responseObj']['accounts'][0];
//       setState(() {
//         depositData = AccountModel.fromJson(accountData);
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Error loading financial data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Deposits Donut Chart'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   if (depositData != null) _buildDepositChart(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildDepositChart() {
//     final deposit = depositData!;
//     final principal =
//         double.parse(deposit.availableBalance.replaceAll(',', ''));
//     // The interest amount is not available in AccountModel, so we'll use a placeholder
//     final interest = principal * 0.1; // Assuming 10% interest for example

//     return HalfDonutChart(
//       title: 'Deposits',
//       centerText: 'Available Balance',
//       percentage: '${deposit.currency} ${deposit.availableBalance}',
//       sections: [
//         DonutChartSectionDetails(
//           value: principal,
//           label: 'Principal',
//           amount: '${deposit.currency} ${deposit.availableBalance}',
//           date: '', // accOpenDate is not in AccountModel
//           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
//         ),
//         DonutChartSectionDetails(
//           value: interest,
//           label: 'Interest (Example)',
//           amount: '${deposit.currency} ${interest.toStringAsFixed(2)}',
//           date: '', // maturityDate is not in AccountModel
//           colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
//         ),
//       ],
//     );
//   }
// }
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/financials/deposit_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DepositsChartExample extends StatefulWidget {
  const DepositsChartExample({Key? key, required AccountModel deposit}) : super(key: key);

  @override
  _DepositsChartExampleState createState() => _DepositsChartExampleState();
}

class _DepositsChartExampleState extends State<DepositsChartExample> {
  DepositAccount? depositData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final depositJson =
          await rootBundle.loadString('mock/dashboard/deposits_mock.json');
      final decodedJson = json.decode(depositJson);
      final response = DepositAccountResponse.fromJson(decodedJson);

      setState(() {
        // Take the first account only (like before)
        depositData = response.accounts.first;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading financial data: $e');
    }
  }

  double _safeParse(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deposits Donut Chart')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (depositData != null) _buildDepositChart(),
                ],
              ),
            ),
    );
  }

  Widget _buildDepositChart() {
    final deposit = depositData!;
    final principal = _safeParse(deposit.depositAmount);
    final interest = _safeParse(deposit.interestAmount);

    return HalfDonutChart(
      title: 'Deposits',
      centerText: 'Balance',
      percentage:
          '${deposit.currency} ${(principal + interest).toStringAsFixed(2)}',
      sections: [
        DonutChartSectionDetails(
          value: principal,
          label: 'Principal',
          amount: '${deposit.currency} ${principal.toStringAsFixed(2)}',
          date: deposit.accOpenDate,
          colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
        ),
        DonutChartSectionDetails(
          value: interest,
          label: 'Interest',
          amount: '${deposit.currency} ${interest.toStringAsFixed(2)}',
          date: deposit.maturityDate,
          colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
        ),
      ],
    );
  }
}
