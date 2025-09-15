

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/financials/deposit_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';
import 'package:flutter/material.dart';

class DepositsChartExample extends StatefulWidget {
  final DepositAccount deposit;

  const DepositsChartExample({Key? key, required this.deposit})
      : super(key: key);

  @override
  State<DepositsChartExample> createState() => _DepositsChartExampleState();
}

class _DepositsChartExampleState extends State<DepositsChartExample> {
  DepositAccount? _detailedDeposit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDepositDetails();
  }

  @override
  void didUpdateWidget(DepositsChartExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.deposit.accountNo != oldWidget.deposit.accountNo) {
      _loadDepositDetails();
    }
  }

  Future<void> _loadDepositDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final depositJson =
          await rootBundle.loadString('mock/dashboard/deposits_mock.json');
      final decodedJson = json.decode(depositJson);
      final response = DepositAccountResponse.fromJson(decodedJson);
      final foundAccount = response.accounts.firstWhere(
        (acc) => acc.accountNo == widget.deposit.accountNo,
        orElse: () => response.accounts.first, // Fallback
      );

      setState(() {
        _detailedDeposit = foundAccount;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading detailed deposit data: $e');
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
    if (_detailedDeposit == null) {
      return const Center(child: Text('Could not load deposit details.'));
    }

    return _buildDepositChart();
  }

  Widget _buildDepositChart() {
    final deposit = _detailedDeposit!;
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
