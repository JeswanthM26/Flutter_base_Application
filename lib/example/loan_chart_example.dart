
// import 'package:Retail_Application/models/financials/loan_model.dart';
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class LoansChartExample extends StatefulWidget {
//   const LoansChartExample({Key? key}) : super(key: key);

//   @override
//   _LoansChartExampleState createState() => _LoansChartExampleState();
// }

// class _LoansChartExampleState extends State<LoansChartExample> {
//   LoanResponse? loanData;
//   Loan? selectedLoan;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final loanJson =
//           await rootBundle.loadString('mock/dashboard/loans_mock.json');
//       setState(() {
//         loanData = loanResponseFromJson(loanJson);
//         if (loanData != null && loanData!.loans.isNotEmpty) {
//           selectedLoan = loanData!.loans.first;
//         }
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
//         title: const Text('Loans Donut Chart'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   if (loanData != null) _buildLoanDropdown(),
//                   const SizedBox(height: 20),
//                   if (selectedLoan != null) _buildLoanChart(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildLoanDropdown() {
//     return DropdownButton<Loan>(
//       value: selectedLoan,
//       isExpanded: true,
//       items: loanData!.loans.map((Loan loan) {
//         return DropdownMenuItem<Loan>(
//           value: loan,
//           child: Text(loan.accountNo),
//         );
//       }).toList(),
//       onChanged: (Loan? newValue) {
//         setState(() {
//           selectedLoan = newValue;
//         });
//       },
//     );
//   }

//   Widget _buildLoanChart() {
//     final loan = selectedLoan!;
//     final currentBalance = double.parse(loan.currentBalance.replaceAll(',', ''));
//     const totalLoanAmount = 100000.0; // Assumed total loan amount
//     final repaidAmount = totalLoanAmount - currentBalance;

//     return HalfDonutChart(
//       title: 'Loan Repayment Progress',
//       centerText: 'Interest Rate',
//       percentage: '8.66%', // Mock data from figma
//       sections: [
//         DonutChartSectionDetails(
//           value: repaidAmount,
//           label: 'Repaid Amount',
//           amount: '\$ ${repaidAmount.toStringAsFixed(2)}',
//           date: "10 Dec '20",
//           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
//         ),
//         DonutChartSectionDetails(
//           value: currentBalance,
//           label: 'Outstanding',
//           amount: '\$ ${currentBalance.toStringAsFixed(2)}',
//           date: "10 Dec '30",
//           colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
//         ),
//       ],
//     );
//   }
// }
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class LoansChartExample extends StatefulWidget {
  const LoansChartExample({Key? key, required AccountModel loan}) : super(key: key);

  @override
  _LoansChartExampleState createState() => _LoansChartExampleState();
}

class _LoansChartExampleState extends State<LoansChartExample> {
  AccountModel? loanData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loanJson =
          await rootBundle.loadString('mock/dashboard/loans_mock.json');
      final decodedJson = json.decode(loanJson);
      final accountData =
          decodedJson['APZRMB__LoanDetails_Res']['apiResponse']['ResponseBody']['responseObj']['loans'][0];
      setState(() {
        loanData = AccountModel.fromJson(accountData);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading financial data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans Donut Chart'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (loanData != null) _buildLoanChart(),
                ],
              ),
            ),
    );
  }

  Widget _buildLoanChart() {
    final loan = loanData!;
    final currentBalance =
        double.parse(loan.availableBalance.replaceAll(',', ''));
    const totalLoanAmount = 100000.0; // Assumed total loan amount
    final repaidAmount = totalLoanAmount - currentBalance;

    return HalfDonutChart(
      title: 'Loan Repayment Progress',
      centerText: 'Available Balance',
      percentage: '${loan.currency} ${loan.availableBalance}',
      sections: [
        DonutChartSectionDetails(
          value: repaidAmount,
          label: 'Repaid Amount',
          amount: '\$ ${repaidAmount.toStringAsFixed(2)}',
          date: "10 Dec '20", // Mock data, not in AccountModel
          colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
        ),
        DonutChartSectionDetails(
          value: currentBalance,
          label: 'Outstanding',
          amount: '\$ ${currentBalance.toStringAsFixed(2)}',
          date: "10 Dec '30", // Mock data, not in AccountModel
          colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
        ),
      ],
    );
  }
}
