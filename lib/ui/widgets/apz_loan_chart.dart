import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/models/financials/loan_model.dart';
import 'package:retail_application/ui/components/apz_donut_chart.dart';

class LoansChartExample extends StatefulWidget {
  final Loan loan;

  const LoansChartExample({Key? key, required this.loan}) : super(key: key);

  @override
  State<LoansChartExample> createState() => _LoansChartExampleState();
}

class _LoansChartExampleState extends State<LoansChartExample> {
  late List<Loan> _allLoans; // Store all loans
  Loan? _detailedLoan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllLoans(); // Load JSON once
  }

  // Detect changes in the loan object (when swiping between accounts)
  @override
  void didUpdateWidget(covariant LoansChartExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loan.accountNo != oldWidget.loan.accountNo) {
      _setCurrentLoan(widget.loan.accountNo);
    }
  }

  // Load all loans from the JSON mock file
  Future<void> _loadAllLoans() async {
    try {
      final loanJson =
          await rootBundle.loadString('mock/Dashboard/loans_mock.json');
      final response = loanResponseFromJson(loanJson);
      _allLoans = response.loans;

      // Set the initial loan based on widget.loan
      _setCurrentLoan(widget.loan.accountNo);
    } catch (e) {
      print('Error loading loan data: $e');
      _allLoans = [];
      setState(() {
        _detailedLoan = null;
        _isLoading = false;
      });
    }
  }

  // Update the current loan without flickering
  void _setCurrentLoan(String accountNo) {
    if (_allLoans.isEmpty) {
      setState(() {
        _detailedLoan = null;
        _isLoading = false;
      });
      return;
    }

    final foundLoan = _allLoans.firstWhere(
      (l) => l.accountNo == accountNo,
      orElse: () => _allLoans.first, // Always returns a Loan
    );

    setState(() {
      _detailedLoan = foundLoan;
      _isLoading = false;
    });
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

    final loan = _detailedLoan!;
    final currentBalance = _safeParse(loan.currentBalance);
    final availableBalance = _safeParse(loan.availableBalance);
    final repaidAmount =
        (availableBalance - currentBalance).clamp(0.0, availableBalance);
    final outstandingAmount = currentBalance.clamp(0.0, availableBalance);

    // return SingleChildScrollView(
    //   padding: const EdgeInsets.all(16.0),
    return IgnorePointer(
      child: HalfDonutChart(
        title: 'Repayment Progress',
        centerText: 'Interest Rate',
        percentage: '${loan.interestRate ?? 0}%',
        sections: [
          DonutChartSectionDetails(
            value: repaidAmount,
            label: 'Repaid Amount',
            amount: '${loan.currency} ${repaidAmount.toStringAsFixed(2)}',
            date: "",
            colors: [const Color(0xFFB3E0FF), const Color(0xFFF4F8FF)],
          ),
          DonutChartSectionDetails(
            value: outstandingAmount,
            label: 'Outstanding Amount',
            amount: '${loan.currency} ${outstandingAmount.toStringAsFixed(2)}',
            date: "",
            colors: [const Color(0xFFF4F8FF), const Color(0xFF5AB8F0)],
          ),
        ],
      ),
    );
  }
}
