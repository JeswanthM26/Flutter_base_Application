
// import 'package:Retail_Application/models/dashboard/creditcard_model.dart';
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// import 'package:flutter/material.dart';

// class CreditCardChartExample extends StatelessWidget {
//   final CreditCardModel card;

//   const CreditCardChartExample({Key? key, required this.card})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildCreditCardChart(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCreditCardChart() {
//     // The new CreditCardModel doesn't have creditLmt, so we can't calculate usedCredit accurately.
//     // We'll use cardBalance as usedCredit for this example.
//     final usedCredit = card.cardBalance;
//     final totalCredit = usedCredit + card.availableCredit;
//     final usedPercentage = (usedCredit / totalCredit) * 100;
//     final availablePercentage = 100 - usedPercentage;

//     return HalfDonutChart(
//       title: 'Credit Card Usage',
//       centerText: 'Total Credit Limit',
//       percentage: '${card.currency} ${totalCredit.toStringAsFixed(2)}',
//       sections: [
//         DonutChartSectionDetails(
//           value: usedCredit,
//           label: 'Used',
//           amount: '${card.currency} ${usedCredit.toStringAsFixed(2)}',
//           date: '${usedPercentage.toStringAsFixed(1)}%',
//           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
//         ),
//         DonutChartSectionDetails(
//           value: card.availableCredit,
//           label: 'Available',
//           amount:
//               '${card.currency} ${card.availableCredit.toStringAsFixed(2)}',
//           date: '${availablePercentage.toStringAsFixed(1)}%',
//           colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
//         ),
//       ],
//     );
//   }
// }



import 'package:Retail_Application/models/dashboard/creditcard_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';

class CreditCardChartExample extends StatelessWidget {
  final CreditCardModel card;

  const CreditCardChartExample({Key? key, required this.card})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCreditCardChart();
  }

  Widget _buildCreditCardChart() {
    final usedCredit = card.cardBalance;
    final totalCredit = usedCredit + card.availableCredit;
    final usedPercentage = totalCredit > 0 ? (usedCredit / totalCredit) * 100 : 0;
    final availablePercentage = 100 - usedPercentage;

    return HalfDonutChart(
      title: 'Credit Card Usage',
      centerText: 'Total Credit Limit',
      percentage: '${card.currency} ${totalCredit.toStringAsFixed(2)}',
      sections: [
        DonutChartSectionDetails(
          value: usedCredit,
          label: 'Used',
          amount: '${card.currency} ${usedCredit.toStringAsFixed(2)}',
          date: '${usedPercentage.toStringAsFixed(1)}%',
          colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
        ),
        DonutChartSectionDetails(
          value: card.availableCredit,
          label: 'Available',
          amount:
              '${card.currency} ${card.availableCredit.toStringAsFixed(2)}',
          date: '${availablePercentage.toStringAsFixed(1)}%',
          colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
        ),
      ],
    );
  }
}