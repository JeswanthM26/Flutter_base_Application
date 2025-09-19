import 'package:flutter/material.dart';
import 'package:Retail_Application/models/dashboard/creditcard_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';

class CreditCardChartExample extends StatefulWidget {
  final CreditCardModel creditData;

  const CreditCardChartExample({
    Key? key,
    required this.creditData,
  }) : super(key: key);

  @override
  State<CreditCardChartExample> createState() => _CreditCardChartExampleState();
}

class _CreditCardChartExampleState extends State<CreditCardChartExample> {
  late List<CreditCardModel> _allCards; // Store all cards if needed
  late CreditCardModel _currentCard;

  @override
  void initState() {
    super.initState();
    // If you already have multiple cards, you can load them here
    _currentCard = widget.creditData;
  }

  @override
  void didUpdateWidget(covariant CreditCardChartExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update chart if a different card is passed in
    if (widget.creditData.cardNumber != oldWidget.creditData.cardNumber) {
      setState(() {
        _currentCard = widget.creditData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = _currentCard;

    final usedCredit = card.cardBalance;
    final totalCredit = usedCredit + card.availableCredit;
    final usedPercentage =
        totalCredit != 0 ? (usedCredit / totalCredit) * 100 : 0.0;
    final availablePercentage = 100 - usedPercentage;

    // return SingleChildScrollView(
    //   padding: const EdgeInsets.all(16.0),
    return IgnorePointer(
      child: HalfDonutChart(
        title: 'Spends Summary',
        centerText: 'Total Credit Limit',
        percentage: '${card.currency} ${totalCredit.toStringAsFixed(2)}',
        sections: [
          DonutChartSectionDetails(
            value: usedCredit,
            label: 'Limit Utilized',
            amount: '${card.currency} ${usedCredit.toStringAsFixed(2)}',
            date: '${usedPercentage.toStringAsFixed(1)}%',
            colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
          ),
          DonutChartSectionDetails(
            value: card.availableCredit,
            label: 'Available Limit',
            amount:
                '${card.currency} ${card.availableCredit.toStringAsFixed(2)}',
            date: '${availablePercentage.toStringAsFixed(1)}%',
            colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
          ),
        ],
      ),
    );
  }
}
