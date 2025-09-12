// import 'package:Retail_Application/models/financials/credit_card_model.dart';
// import 'package:Retail_Application/models/financials/deposit_model.dart' as dm;
// import 'package:Retail_Application/models/financials/loan_model.dart';
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';

// class FinancialDashboardScreen extends StatefulWidget {
//   const FinancialDashboardScreen({Key? key}) : super(key: key);

//   @override
//   _FinancialDashboardScreenState createState() =>
//       _FinancialDashboardScreenState();
// }

// class _FinancialDashboardScreenState extends State<FinancialDashboardScreen> {
//   dm.DepositAccount? depositData;
//   LoanResponse? loanData;
//   CreditCardResponse? creditCardData;
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
//       final loanJson = await rootBundle.loadString('mock/dashboard/loans_mock.json');
//       final creditCardJson =
//           await rootBundle.loadString('mock/dashboard/credit_mock.json');

//       setState(() {
//         depositData = dm.depositAccountFromJson(depositJson);
//         loanData = loanResponseFromJson(loanJson);
//         creditCardData = creditCardResponseFromJson(creditCardJson);
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
//       backgroundColor: const Color(0xFF001A33),
//       appBar: AppBar(
//         title: Text(
//           'Financial Dashboard',
//           style: GoogleFonts.lato(color: Colors.white),
//         ),
//         backgroundColor: const Color(0xFF002A4D),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   if (depositData != null) _buildDepositChart(),
//                   const SizedBox(height: 20),
//                   if (loanData != null) _buildLoanChart(),
//                   const SizedBox(height: 20),
//                   if (creditCardData != null) _buildCreditCardChart(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildDepositChart() {
//     final deposit = depositData!;
//     final principal = double.parse(deposit.depositAmount.replaceAll(',', ''));
//     final interest = double.parse(deposit.interestAmount.replaceAll(',', ''));
//     final total = principal + interest;

//     return HalfDonutChart(
//       title: 'Deposits',
//       centerText: 'Interest Rate',
//       percentage: '${deposit.interestRate}%',
//       amount1: '${deposit.currency} ${deposit.depositAmount}',
//       amount2: '${deposit.currency} ${deposit.interestAmount}',
//       date1: deposit.accOpenDate,
//       date2: deposit.maturityDate,
//       legend1: 'Deposited',
//       legend2: 'Interest',
//       totalValue: total,
//       sections: [
//         PieChartSectionData(
//           value: principal,
//           color: const Color(0xFFB3E0FF),
//           title: '',
//           radius: 25,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFB3E0FF), Color(0xFFF4F8FF)],
//           ),
//         ),
//         PieChartSectionData(
//           value: interest,
//           color: const Color(0xFF5AB8F0),
//           title: '',
//           radius: 25,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFF4F8FF), Color(0xFF5AB8F0)],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLoanChart() {
//     final loan = loanData!.loans.first;
//     final currentBalance = double.parse(loan.currentBalance.replaceAll(',', ''));
//     const totalLoanAmount = 100000.0; // Assumed total loan amount
//     final repaidAmount = totalLoanAmount - currentBalance;

//     return HalfDonutChart(
//       title: 'Loan Repayment Progress',
//       centerText: 'Interest Rate',
//       percentage: '8.66%', // Mock data from figma
//       amount1: '\$ ${repaidAmount.toStringAsFixed(2)}',
//       amount2: '\$ ${currentBalance.toStringAsFixed(2)}',
//       date1: "10 Dec '20", // Mock data from figma
//       date2: "10 Dec '30", // Mock data from figma
//       legend1: 'Repaid Amount',
//       legend2: 'Outstanding',
//       totalValue: totalLoanAmount,
//       sections: [
//         PieChartSectionData(
//           value: repaidAmount,
//           color: const Color(0xFFB3E0FF),
//           title: '',
//           radius: 25,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFB3E0FF), Color(0xFFF4F8FF)],
//           ),
//         ),
//         PieChartSectionData(
//           value: currentBalance,
//           color: const Color(0xFF5AB8F0),
//           title: '',
//           radius: 25,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFF4F8FF), Color(0xFF5AB8F0)],
//           ),
//         ),
//       ],
//     );
//   }

//    Widget _buildCreditCardChart() {
//     final card = creditCardData!.creditCards.first;
//     final usedCredit = card.creditLmt - card.availableCredit;
//     final usedPercentage = (usedCredit / card.creditLmt) * 100;
//     final availablePercentage = (card.availableCredit / card.creditLmt) * 100;

//     return HalfDonutChart(
//       title: 'Credit Card Usage',
//       centerText: 'Used Credit',
//       percentage: '${usedPercentage.toStringAsFixed(1)}%',
//       amount1: '${card.currency} ${usedCredit.toStringAsFixed(2)}\n'
//           '${usedPercentage.toStringAsFixed(1)}%',
//       amount2: '${card.currency} ${card.availableCredit.toStringAsFixed(2)}\n'
//           '${availablePercentage.toStringAsFixed(1)}%',
//       date1: '',
//       date2: '',
//       legend1: 'Used',
//       legend2: 'Available',
//       totalValue: card.creditLmt.toDouble(),
//       sections: [
//         PieChartSectionData(
//           value: usedCredit.toDouble(),
//           color: const Color(0xFFB3E0FF),
//           title: '',
//           radius: 25,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFB3E0FF), Color(0xFFF4F8FF)],
//           ),
//         ),
//         PieChartSectionData(
//           value: card.availableCredit.toDouble(),
//           color: const Color(0xFF5AB8F0),
//           title: '',
//           radius: 25,
//           gradient: const LinearGradient(
//             colors: [Color(0xFFF4F8FF), Color(0xFF5AB8F0)],
//           ),
//         ),
//       ],
//     );
//   }
// }

// // import 'package:Retail_Application/models/financials/credit_card_model.dart';
// // import 'package:Retail_Application/models/financials/deposit_model.dart' as dm;
// // import 'package:Retail_Application/models/financials/loan_model.dart';
// // import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class FinancialDashboardScreen extends StatefulWidget {
// //   const FinancialDashboardScreen({Key? key}) : super(key: key);

// //   @override
// //   _FinancialDashboardScreenState createState() =>
// //       _FinancialDashboardScreenState();
// // }

// // class _FinancialDashboardScreenState extends State<FinancialDashboardScreen> {
// //   dm.DepositAccount? depositData;
// //   LoanResponse? loanData;
// //   CreditCardResponse? creditCardData;
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //   }

// //   Future<void> _loadData() async {
// //     try {
// //       final depositJson =
// //           await rootBundle.loadString('mock/Dashboard/deposits_mock.json');
// //       final loanJson = await rootBundle.loadString('mock/Dashboard/loans_mock.json');
// //       final creditCardJson =
// //           await rootBundle.loadString('mock/Dashboard/credit_mock.json');

// //       setState(() {
// //         depositData = dm.depositAccountFromJson(depositJson);
// //         loanData = loanResponseFromJson(loanJson);
// //         creditCardData = creditCardResponseFromJson(creditCardJson);
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
// //       backgroundColor: const Color(0xFF001A33),
// //       appBar: AppBar(
// //         title: Text(
// //           'Financial Dashboard',
// //           style: GoogleFonts.lato(color: Colors.white),
// //         ),
// //         backgroundColor: const Color(0xFF002A4D),
// //       ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : SingleChildScrollView(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 children: [
// //                   if (depositData != null) _buildDepositChart(),
// //                   const SizedBox(height: 20),
// //                   if (loanData != null) _buildLoanChart(),
// //                   const SizedBox(height: 20),
// //                   if (creditCardData != null) _buildCreditCardChart(),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildDepositChart() {
// //     final deposit = depositData!;
// //     final balance = double.parse(deposit.depositAmount.replaceAll(',', ''));

// //     return HalfDonutChart(
// //       title: 'Deposits',
// //       centerText: 'Interest Rate',
// //       percentage: '${deposit.interestRate}%',
// //       amount1: '${deposit.currency} ${deposit.depositAmount}',
// //       amount2: '${deposit.currency} ${deposit.interestAmount}',
// //       date1: deposit.accOpenDate,
// //       date2: deposit.maturityDate,
// //       legend1: 'Deposited',
// //       legend2: 'Interest',
// //       totalValue: balance,
// //       sections: [
// //         PieChartSectionData(
// //           value: balance,
// //           color: const Color(0xFF5AB8F0),
// //           title: '',
// //           radius: 25,
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFFF4F8FF), Color(0xFF5AB8F0)],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildLoanChart() {
// //     final loan = loanData!.loans.first;
// //     final currentBalance = double.parse(loan.currentBalance.replaceAll(',', ''));
// //     const totalLoanAmount = 100000.0; // Assumed total loan amount
// //     final repaidAmount = totalLoanAmount - currentBalance;
// //     final repaidPercentage = (repaidAmount / totalLoanAmount) * 100;

// //     return HalfDonutChart(
// //       title: 'Loan Repayment Progress',
// //       centerText: 'Interest Rate',
// //       percentage: '8.66%', // Mock data from figma
// //       amount1: '\$ ${repaidAmount.toStringAsFixed(2)}',
// //       amount2: '\$ ${currentBalance.toStringAsFixed(2)}',
// //       date1: '10 Dec \'20', // Mock data from figma
// //       date2: '10 Dec \'30', // Mock data from figma
// //       legend1: 'Repaid Amount',
// //       legend2: 'Outstanding',
// //       totalValue: totalLoanAmount,
// //       sections: [
// //         PieChartSectionData(
// //           value: repaidAmount,
// //           color: const Color(0xFFB3E0FF),
// //           title: '',
// //           radius: 25,
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFFB3E0FF), Color(0xFFF4F8FF)],
// //           ),
// //         ),
// //         PieChartSectionData(
// //           value: currentBalance,
// //           color: const Color(0xFF5AB8F0),
// //           title: '',
// //           radius: 25,
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFFF4F8FF), Color(0xFF5AB8F0)],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildCreditCardChart() {
// //     final card = creditCardData!.creditCards.first;
// //     final usedCredit = card.creditLmt - card.availableCredit;
// //     final usedPercentage = (usedCredit / card.creditLmt) * 100;

// //     return HalfDonutChart(
// //       title: 'Credit Card Usage',
// //       centerText: 'Used Credit',
// //       percentage: '${usedPercentage.toStringAsFixed(1)}%',
// //       amount1: '${usedPercentage.toStringAsFixed(1)}% used',
// //       amount2: '${card.currency} ${card.availableCredit.toStringAsFixed(2)}',
// //       date1: '',
// //       date2: '',
// //       legend1: 'Used',
// //       legend2: 'Available',
// //       totalValue: card.creditLmt.toDouble(),
// //       sections: [
// //         PieChartSectionData(
// //           value: usedCredit.toDouble(),
// //           color: const Color(0xFFB3E0FF),
// //           title: '',
// //           radius: 25,
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFFB3E0FF), Color(0xFFF4F8FF)],
// //           ),
// //         ),
// //         PieChartSectionData(
// //           value: card.availableCredit.toDouble(),
// //           color: const Color(0xFF5AB8F0),
// //           title: '',
// //           radius: 25,
// //           gradient: const LinearGradient(
// //             colors: [Color(0xFFF4F8FF), Color(0xFF5AB8F0)],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
import 'package:Retail_Application/example/credit_chart_example.dart';
import 'package:Retail_Application/example/deposit_chart_example.dart';
import 'package:Retail_Application/example/loan_chart_example.dart';
import 'package:flutter/material.dart';

class FinancialDashboardScreen extends StatelessWidget {
  const FinancialDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Dashboards'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Deposits Chart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DepositsChartExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Loans Chart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoansChartExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Credit Card Chart'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreditCardChartExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
