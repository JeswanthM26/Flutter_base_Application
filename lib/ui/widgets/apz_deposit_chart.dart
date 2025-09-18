import 'package:flutter/material.dart';
import 'package:Retail_Application/models/financials/deposit_model.dart';
import 'package:Retail_Application/ui/components/apz_donut_chart.dart';

class DepositsChartExample extends StatefulWidget {
  final DepositAccount depositData;

  const DepositsChartExample({
    Key? key,
    required this.depositData,
  }) : super(key: key);

  @override
  State<DepositsChartExample> createState() => _DepositsChartExampleState();
}

class _DepositsChartExampleState extends State<DepositsChartExample> {
  late List<DepositAccount>
      _allDeposits; // Optional: store all deposits if needed
  late DepositAccount _currentDeposit;

  @override
  void initState() {
    super.initState();
    _currentDeposit = widget.depositData;
    // If you have multiple deposits, you can load them here once
    _allDeposits = [
      widget.depositData
    ]; // initialize with at least current deposit
  }

  @override
  void didUpdateWidget(covariant DepositsChartExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update chart if a different deposit is passed in
    if (widget.depositData.accountNo != oldWidget.depositData.accountNo) {
      setState(() {
        _currentDeposit = widget.depositData;
      });
    }
  }
  
  
  double _safeParse(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final principal = _safeParse(_currentDeposit.depositAmount);
    final interest = _safeParse(_currentDeposit.interestAmount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: HalfDonutChart(
        title: 'Deposits',
        centerText: 'Interest Rate',
        percentage: '${_currentDeposit.interestRate}%',
        sections: [
          DonutChartSectionDetails(
            value: principal,
            label: 'Principal',
            amount:
                '${_currentDeposit.currency} ${principal.toStringAsFixed(2)}',
            date: _currentDeposit.accOpenDate,
            colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
          ),
          DonutChartSectionDetails(
            value: interest,
            label: 'Interest',
            amount:
                '${_currentDeposit.currency} ${interest.toStringAsFixed(2)}',
            date: _currentDeposit.maturityDate,
            colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
          ),
        ],
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/models/financials/deposit_model.dart';
// import 'package:Retail_Application/ui/components/apz_donut_chart.dart';

// class DepositsChartExample extends StatefulWidget {
//   final DepositAccount deposit;

//   const DepositsChartExample({Key? key, required this.deposit})
//       : super(key: key);

//   @override
//   State<DepositsChartExample> createState() => _DepositsChartExampleState();
// }

// class _DepositsChartExampleState extends State<DepositsChartExample> {
//   DepositAccount? _detailedDeposit;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadDepositDetails();
//   }

//   @override
//   void didUpdateWidget(DepositsChartExample oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.deposit.accountNo != oldWidget.deposit.accountNo) {
//       _loadDepositDetails();
//     }
//   }

//   Future<void> _loadDepositDetails() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final depositJson =
//           await rootBundle.loadString('mock/dashboard/deposits_mock.json');
//       final decodedJson = json.decode(depositJson);

//       final response = DepositAccountResponse.fromJson(decodedJson);

//       final foundAccount = response.accounts.firstWhere(
//         (acc) => acc.accountNo == widget.deposit.accountNo,
//         orElse: () => response.accounts.first,
//       );

//       print('Loaded account: ${foundAccount.accountNo}'); // Debug print

//       setState(() {
//         _detailedDeposit = foundAccount;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading deposit details: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   double _safeParse(String? value) {
//     if (value == null || value.isEmpty) return 0.0;
//     return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) return const Center(child: CircularProgressIndicator());
//     if (_detailedDeposit == null)
//       return const Center(child: Text('Could not load deposit details.'));

//     return _buildDepositChart();
//   }

//   Widget _buildDepositChart() {
//     final deposit = _detailedDeposit!;
//     final principal = _safeParse(deposit.depositAmount);
//     final interest = _safeParse(deposit.interestAmount);
//     final total = principal + interest;

//     return HalfDonutChart(
//       title: 'Deposits',
//       centerText: 'Total Deposit',
//       percentage: '${deposit.currency} ${total.toStringAsFixed(2)}',
//       sections: [
//         DonutChartSectionDetails(
//           value: principal,
//           label: 'Deposit Amount',
//           amount: '${deposit.currency} ${principal.toStringAsFixed(2)}',
//           date: deposit.accOpenDate,
//           colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
//         ),
//         DonutChartSectionDetails(
//           value: interest,
//           label: 'Interest',
//           amount: '${deposit.currency} ${interest.toStringAsFixed(2)}',
//           date: deposit.maturityDate,
//           colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
//         ),
//       ],
//     );
//   }
// }
