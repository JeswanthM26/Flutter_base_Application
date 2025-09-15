import 'package:Retail_Application/models/financials/deposit_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class DepositsChartExample extends StatefulWidget {
  const DepositsChartExample({Key? key}) : super(key: key);

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
//appBar: AppBar(title: const Text('Deposits Donut Chart')),
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
