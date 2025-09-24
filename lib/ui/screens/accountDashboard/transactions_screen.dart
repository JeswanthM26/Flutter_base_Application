import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:retail_application/models/dashboard/account_model.dart';
import 'package:retail_application/models/dashboard/accountstatement_model.dart';
import 'package:retail_application/ui/components/apz_searchbar.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:retail_application/ui/screens/Profile/profile_screen.dart';

import '../../../themes/apz_app_themes.dart';
 
class TransactionsScreen extends StatefulWidget {
  final AccountModel account;
 
  const TransactionsScreen({super.key, required this.account});
 
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}
 
class _TransactionsScreenState extends State<TransactionsScreen> {
  List<AccountStatementModel> allStatements = [];
  AccountStatementModel? selectedStatement;
  final TextEditingController searchController = TextEditingController();
  List<TransactionTrendModel> trendFiltered = [];
 
  Map<String, double> monthlyCredits = {};
  Map<String, double> monthlyDebits = {};
  String accountCurrency = '';
 
  String selectedChip = 'All';
  List<String> chips = [];
 
  @override
  void initState() {
    super.initState();
    loadAccountStatements();
  }
 
  Future<void> loadAccountStatements() async {
    final String jsonString =
        await rootBundle.loadString('mock/Dashboard/accountstatement_mock.json');
    final data = json.decode(jsonString);
 
    List statements =
        data['apiResponse']['ResponseBody']['responseObj']['transactionDetails'] ?? [];
    allStatements =
        statements.map((e) => AccountStatementModel.fromJson(e)).toList();
 
    selectedStatement = allStatements.firstWhere(
      (statement) =>
          statement.accountNo.replaceAll(' ', '') ==
          widget.account.accountNo.replaceAll(' ', ''),
      orElse: () => AccountStatementModel(accountNo: '', trend: []),
    );
 
    trendFiltered = selectedStatement?.trend ?? [];
    if (trendFiltered.isNotEmpty) accountCurrency = trendFiltered.first.trnCcy ?? '';
 
    chips = ['All', 'Amount (1k-4k)', 'Last 30 Days', 'Credit', 'ATM'];
 
    _applyFilters();
  }
 
  void _groupTransactionsByMonth() {
    monthlyCredits.clear();
    monthlyDebits.clear();
    for (var trn in trendFiltered) {
      if (trn.trnDate != null && trn.trnDate!.isNotEmpty) {
        try {
          DateTime? date = DateTime.tryParse(trn.trnDate!);
          if (date == null) continue;
          String monthKey =
              '${date.year}-${date.month.toString().padLeft(2, '0')}';
          if ((trn.drcrIndicator ?? '') == 'CR') {
            monthlyCredits[monthKey] =
                (monthlyCredits[monthKey] ?? 0) + trn.trnAmount;
          } else {
            monthlyDebits[monthKey] =
                (monthlyDebits[monthKey] ?? 0) + trn.trnAmount;
          }
        } catch (e) {}
      }
    }
  }
 
  void _applyFilters() {
    if (selectedStatement == null || selectedStatement!.trend == null) {
      trendFiltered = [];
      if (mounted) setState(() {});
      return;
    }
 
    List<TransactionTrendModel> filtered = List.from(selectedStatement!.trend!);
 
    switch (selectedChip) {
      case 'All':
        break;
      case 'Amount (1k-4k)':
        filtered = filtered
            .where((trn) => trn.trnAmount >= 1000 && trn.trnAmount <= 4000)
            .toList();
        break;
      case 'Last 30 Days':
        final now = DateTime.now();
        final cutoff = now.subtract(const Duration(days: 30));
        filtered = filtered.where((trn) {
          try {
            if (trn.trnDate == null || trn.trnDate!.isEmpty) return false;
            final date = DateTime.tryParse(trn.trnDate!);
            if (date == null) return false;
            return date.isAfter(cutoff) &&
                date.isBefore(now.add(const Duration(days: 1)));
          } catch (e) {
            return false;
          }
        }).toList();
        break;
      case 'Credit':
        filtered = filtered.where((trn) => trn.drcrIndicator == 'CR').toList();
        break;
      case 'ATM':
        filtered = filtered
            .where((trn) => trn.trnDesc?.toLowerCase().contains('atm') ?? false)
            .toList();
        break;
    }
 
    // Search filter
    if (searchController.text.isNotEmpty) {
      final searchText = searchController.text.toLowerCase();
      filtered = filtered
          .where((trn) => (trn.trnDesc ?? '').toLowerCase().contains(searchText))
          .toList();
    }
 
    trendFiltered = filtered;
    _groupTransactionsByMonth();
 
    if (mounted) setState(() {});
  }
 
  String _monthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
 
  List<String> _getLast6Months() {
    final now = DateTime.now();
    List<String> last6 = [];
    for (int i = 5; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      last6.add('${d.year}-${d.month.toString().padLeft(2, '0')}');
    }
    return last6;
  }
 
  double _calculateMaxY() {
    final allValues = [
      ...monthlyCredits.values,
      ...monthlyDebits.values,
    ];
    if (allValues.isEmpty) return 10;
    final maxVal = allValues.reduce((a, b) => a > b ? a : b);
    return maxVal * 1.2;
  }
 
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final accountName = widget.account.acctName ?? 'Account';
    final last6Months = _getLast6Months();
    final maxY = _calculateMaxY();
    final yInterval = maxY / 3;
    final safeYInterval = (yInterval == 0 ? 1 : yInterval).toDouble();
 
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: ProfileHeaderWidget(
                title: 'Transactions',
                onBackPressed: () => Navigator.pop(context),
                trailingIcon: Icons.home,
                onActionPressed: () => Navigator.pop(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApzText(
                    label:
                        '${widget.account.currency} ${widget.account.availableBalance}',
                    fontSize: 24,
                    fontWeight: ApzFontWeight.headingSemibold,
                    color: AppColors.primary_text(context),
                  ),
                  const SizedBox(height: 4),
                  ApzText(
                    label: "$accountName's Account",
                    fontSize: 13,
                    fontWeight: ApzFontWeight.bodyRegular,
                    color: AppColors.primary_text(context),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 202,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    barGroups: List.generate(last6Months.length, (i) {
                      final key = last6Months[i];
                      final credit = monthlyCredits[key] ?? 0;
                      final debit = monthlyDebits[key] ?? 0;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                              toY: credit,
                              color: const Color.fromARGB(255, 99, 197, 140),
                              width: 12,
                              borderRadius: BorderRadius.circular(3)),
                          BarChartRodData(
                              toY: debit,
                              color: const Color.fromARGB(255, 218, 138, 138),
                              width: 12,
                              borderRadius: BorderRadius.circular(3)),
                        ],
                        barsSpace: 6,
                      );
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: safeYInterval,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(0),
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[500]),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < 0 ||
                                value.toInt() >= last6Months.length) return const SizedBox();
                            final parts = last6Months[value.toInt()].split('-');
                            final month = int.parse(parts[1]);
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _monthAbbreviation(month),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary_text(context)),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                      horizontalInterval: safeYInterval,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.shade300.withOpacity(0.3), strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ApzSearchBar(
                type: AppzSearchBarType.primary,
                placeholder: 'Search transactions',
                controller: searchController,
                items: selectedStatement?.trend ?? [],
                labelSelector: (item) => item.trnDesc ?? '',
                onFiltered: (_) => _applyFilters(),
              ),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: chips.map((chip) {
                  final isSelected = chip == selectedChip;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChip = chip;
                          _applyFilters();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary(context)
                              : AppColors.cardBackground(context),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ApzText(
                          label: chip,
                          fontSize: 14,
                          fontWeight: ApzFontWeight.bodyMedium,
                          color: isSelected
                              ? Colors.white
                              : AppColors.primary_text(context),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            ...trendFiltered.map((trn) => TransactionCardWidget(trn: trn)).toList(),
            if (trendFiltered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: ApzText(
                    label: 'No transactions found.',
                    fontSize: 16,
                    fontWeight: ApzFontWeight.bodyMedium,
                    color: AppColors.primary_text(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
 
// ---------------- Transaction Card ----------------
class TransactionCardWidget extends StatelessWidget {
  final TransactionTrendModel trn;
 
  const TransactionCardWidget({super.key, required this.trn});
 
  @override
  Widget build(BuildContext context) {
    bool isCredit = trn.drcrIndicator == 'CR';
    Color amountColor =
        isCredit ? const Color(0xFF46A85F) : const Color(0xFFFFB4AB);
 
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isCredit ? const Color(0xFFA5D6A7) : const Color(0xFFF8BAD0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              size: 20,
              color: AppColors.primary_text(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApzText(
                  label: trn.trnDate ?? '-',
                  fontSize: 14,
                  fontWeight: ApzFontWeight.bodyRegular,
                  color: AppColors.primary_text(context),
                ),
                const SizedBox(height: 4),
                ApzText(
                  label: trn.trnDesc ?? '-',
                  fontSize: 12,
                  fontWeight: ApzFontWeight.bodyRegular,
                  color: AppColors.primary_text(context).withOpacity(0.7),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ApzText(
                label:
                    '${isCredit ? '+' : '-'} ${trn.trnAmount.toStringAsFixed(2)} ${trn.trnCcy ?? ''}',
                fontSize: 14,
                fontWeight: ApzFontWeight.bodyRegular,
                color: amountColor,
              ),
              const SizedBox(height: 4),
              ApzText(
                label: trn.runningBalance != null
                    ? '${trn.runningBalance!.toStringAsFixed(2)} ${trn.trnCcy ?? ''}'
                    : '',
                fontSize: 12,
                fontWeight: ApzFontWeight.bodyRegular,
                color: AppColors.primary_text(context).withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 
 