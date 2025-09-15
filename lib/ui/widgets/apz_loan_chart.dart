
// import 'package:Retail_Application/models/dashboard/account_model.dart';
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// import 'package:flutter/material.dart';

// class LoansChartExample extends StatelessWidget {
//   final AccountModel loan;

//   const LoansChartExample({Key? key, required this.loan}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildLoanChart(),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoanChart() {
//     final currentBalance =
//         double.parse(loan.availableBalance.replaceAll(',', ''));
//     const totalLoanAmount = 100000.0; // Assumed total loan amount
//     final repaidAmount = totalLoanAmount - currentBalance;

//     return HalfDonutChart(
//       title: 'Loan Repayment Progress',
//       centerText: 'Available Balance',
//       percentage: '${loan.currency} ${loan.availableBalance}',
//       sections: [
//         DonutChartSectionDetails(
//           value: repaidAmount,
//           label: 'Repaid Amount',
//           amount: '\$ ${repaidAmount.toStringAsFixed(2)}',
//           date: "10 Dec '20", // Mock data, not in AccountModel
//           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
//         ),
//         DonutChartSectionDetails(
//           value: currentBalance,
//           label: 'Outstanding',
//           amount: '\$ ${currentBalance.toStringAsFixed(2)}',
//           date: "10 Dec '30", // Mock data, not in AccountModel
//           colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
//         ),
//       ],
//     );
//   }
// }
// import 'package:Retail_Application/models/dashboard/account_model.dart';
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// import 'package:flutter/material.dart';

// class LoansChartExample extends StatelessWidget {
//   final AccountModel loan;

//   const LoansChartExample({Key? key, required this.loan}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildLoanChart(),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoanChart() {
//     final currentBalance =
//         double.parse(loan.availableBalance.replaceAll(',', ''));
//     const totalLoanAmount = 100000.0; // Assumed total loan amount
//     final repaidAmount = (totalLoanAmount - currentBalance).clamp(0.0, totalLoanAmount);
//     final outstanding = currentBalance.clamp(0.0, totalLoanAmount);


//     return HalfDonutChart(
//       title: 'Loan Repayment Progress',
//       centerText: 'Available Balance',
//       percentage: '${loan.currency} ${loan.availableBalance}',
//       sections: [
//         DonutChartSectionDetails(
//           value: repaidAmount,
//           label: 'Repaid Amount',
//           amount: '\$ ${repaidAmount.toStringAsFixed(2)}',
//           date: "10 Dec '20", // Mock data, not in AccountModel
//           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
//         ),
//         DonutChartSectionDetails(
//           value: outstanding,
//           label: 'Outstanding',
//           amount: '\$ ${outstanding.toStringAsFixed(2)}',
//           date: "10 Dec '30", // Mock data, not in AccountModel
//           colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
//         ),
//       ],
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/financials/loan_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';

class LoansChartExample extends StatefulWidget {
  final Loan loan;

  const LoansChartExample({Key? key, required this.loan}) : super(key: key);

  @override
  State<LoansChartExample> createState() => _LoansChartExampleState();
}

class _LoansChartExampleState extends State<LoansChartExample> {
  Loan? _detailedLoan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoanDetails();
  }

  @override
  void didUpdateWidget(LoansChartExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loan.accountNo != oldWidget.loan.accountNo) {
      _loadLoanDetails();
    }
  }

  Future<void> _loadLoanDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final loanJson =
          await rootBundle.loadString('mock/dashboard/loans_mock.json');
      final response = loanResponseFromJson(loanJson);
      final foundAccount = response.loans.firstWhere(
        (l) => l.accountNo == widget.loan.accountNo,
        orElse: () => response.loans.first, // Fallback
      );

      setState(() {
        _detailedLoan = foundAccount;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading detailed loan data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _safeParse(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_detailedLoan == null) {
      return const Center(child: Text('Could not load loan details.'));
    }
    return _buildLoanChart();
  }

  Widget _buildLoanChart() {
    final loan = _detailedLoan!;
    final currentBalance = _safeParse(loan.currentBalance);
    const totalLoanAmount = 100000.0; // Assumed total loan amount
    final repaidAmount = (totalLoanAmount - currentBalance).clamp(0.0, totalLoanAmount);
    final outstanding = currentBalance.clamp(0.0, totalLoanAmount);

    return HalfDonutChart(
      title: 'Loan Repayment Progress',
      centerText: 'Available Balance',
      percentage: '${loan.currency} ${loan.currentBalance}',
      sections: [
        DonutChartSectionDetails(
          value: repaidAmount,
          label: 'Repaid Amount',
          amount: '\$ ${repaidAmount.toStringAsFixed(2)}',
          date: "", // Mock data, not in model
          colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
        ),
        DonutChartSectionDetails(
          value: outstanding,
          label: 'Outstanding',
          amount: '\$ ${outstanding.toStringAsFixed(2)}',
          date: "", // Mock data, not in model
          colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
        ),
      ],
    );
  }
}
