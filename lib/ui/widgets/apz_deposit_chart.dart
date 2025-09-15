import 'package:Retail_Application/models/financials/deposit_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';

class DepositsChartExample extends StatelessWidget {
  final DepositAccount depositData;

  const DepositsChartExample({
    Key? key,
    required this.depositData,
  }) : super(key: key);

  double _safeParse(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final principal = _safeParse(depositData.depositAmount);
    final interest = _safeParse(depositData.interestAmount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: HalfDonutChart(
        title: 'Deposits',
        centerText: 'Balance',
        percentage:
            '${depositData.currency} ${(principal + interest).toStringAsFixed(2)}',
        sections: [
          DonutChartSectionDetails(
            value: principal,
            label: 'Principal',
            amount: '${depositData.currency} ${principal.toStringAsFixed(2)}',
            date: depositData.accOpenDate,
            colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
          ),
          DonutChartSectionDetails(
            value: interest,
            label: 'Interest',
            amount: '${depositData.currency} ${interest.toStringAsFixed(2)}',
            date: depositData.maturityDate,
            colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
          ),
        ],
      ),
    );
  }
}
