// import 'package:Retail_Application/ui/widgets/apz_creditcard_chart.dart';
// import 'package:Retail_Application/ui/widgets/apz_deposit_chart.dart';
// import 'package:Retail_Application/ui/widgets/apz_loan_chart.dart';
// import 'package:flutter/material.dart';

// class FinancialDashboardScreen extends StatelessWidget {
//   const FinancialDashboardScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Financial Dashboards'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text('Deposits Chart'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const DepositsChartExample(),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Loans Chart'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const LoansChartExample(),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text('Credit Card Chart'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CreditCardChartExample(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
