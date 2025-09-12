
// import 'package:Retail_Application/models/financials/credit_card_model.dart';
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CreditCardChartExample extends StatefulWidget {
//   const CreditCardChartExample({Key? key}) : super(key: key);

//   @override
//   _CreditCardChartExampleState createState() => _CreditCardChartExampleState();
// }

// class _CreditCardChartExampleState extends State<CreditCardChartExample> {
//   CreditCardResponse? creditCardData;
//   CreditCard? selectedCreditCard;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       final creditCardJson =
//           await rootBundle.loadString('mock/dashboard/credit_mock.json');
//       setState(() {
//         creditCardData = creditCardResponseFromJson(creditCardJson);
//         if (creditCardData != null && creditCardData!.creditCards.isNotEmpty) {
//           selectedCreditCard = creditCardData!.creditCards.first;
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
//         title: const Text('Credit Card Donut Chart'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   if (creditCardData != null) _buildCreditCardDropdown(),
//                   const SizedBox(height: 20),
//                   if (selectedCreditCard != null) _buildCreditCardChart(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildCreditCardDropdown() {
//     return DropdownButton<CreditCard>(
//       value: selectedCreditCard,
//       isExpanded: true,
//       items: creditCardData!.creditCards.map((CreditCard card) {
//         return DropdownMenuItem<CreditCard>(
//           value: card,
//           child: Text(card.cardNumber),
//         );
//       }).toList(),
//       onChanged: (CreditCard? newValue) {
//         setState(() {
//           selectedCreditCard = newValue;
//         });
//       },
//     );
//   }

//   Widget _buildCreditCardChart() {
//     final card = selectedCreditCard!;
//     final usedCredit = card.creditLmt - card.availableCredit;
//     final usedPercentage = (usedCredit / card.creditLmt) * 100;
//     final availablePercentage = 100 - usedPercentage;

//     return HalfDonutChart(
//       title: 'Credit Card Usage',
//       centerText: 'Total Credit Limit',
//       percentage: '${card.currency} ${card.creditLmt.toStringAsFixed(2)}',
//       sections: [
//         DonutChartSectionDetails(
//           value: usedCredit.toDouble(),
//           label: 'Used',
//           amount: '${card.currency} ${usedCredit.toStringAsFixed(2)}',
//           date: '${usedPercentage.toStringAsFixed(1)}%',
//           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
//         ),
//         DonutChartSectionDetails(
//           value: card.availableCredit.toDouble(),
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
import 'package:Retail_Application/models/financials/credit_card_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class CreditCardChartExample extends StatefulWidget {
  const CreditCardChartExample({Key? key}) : super(key: key);

  @override
  _CreditCardChartExampleState createState() => _CreditCardChartExampleState();
}

class _CreditCardChartExampleState extends State<CreditCardChartExample> {
  CreditCardModel? creditCardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final creditCardJson =
          await rootBundle.loadString('mock/dashboard/credit_mock.json');
      final decodedJson = json.decode(creditCardJson);
      final cardData = decodedJson['APZRMB__CreditCardDetails_Res']
          ['apiResponse']['ResponseBody']['responseObj']['creditCards'][0];
      setState(() {
        creditCardData = CreditCardModel.fromJson(cardData);
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
        title: const Text('Credit Card Donut Chart'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (creditCardData != null) _buildCreditCardChart(),
                ],
              ),
            ),
    );
  }

  Widget _buildCreditCardChart() {
    final card = creditCardData!;
    // The new CreditCardModel doesn't have creditLmt, so we can't calculate usedCredit accurately.
    // We'll use cardBalance as usedCredit for this example.
    final usedCredit = card.cardBalance;
    final totalCredit = usedCredit + card.availableCredit;
    final usedPercentage = (usedCredit / totalCredit) * 100;
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
