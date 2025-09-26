import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:retail_application/models/dashboard/account_model.dart';
import 'package:retail_application/models/dashboard/accountstatement_model.dart';
import 'package:retail_application/models/filters_model.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/ui/components/apz_searchbar.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:retail_application/ui/screens/Profile/profile_screen.dart';
import 'package:retail_application/ui/screens/accountDashboard/filters.dart';
import 'package:retail_application/ui/screens/accountDashboard/transactionDetails.dart';

class TransactionsScreen extends StatefulWidget {
  final AccountModel account;

  const TransactionsScreen({super.key, required this.account});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
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

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TransactionDetailsSheet(trn: trn),
          ),
        );
      },
      child: Container(
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
                    label: trn.trnDate != null && trn.trnDate!.isNotEmpty
                        ? DateFormat('dd MMM yyyy').format(DateTime.parse(trn.trnDate!))
                        : '-',
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
                  label: '${isCredit ? '+' : '-'} ${trn.trnAmount.toStringAsFixed(2)} ${trn.trnCcy ?? ''}',
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
      ),
    );
  }
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<AccountStatementModel> allStatements = [];
  AccountStatementModel? selectedStatement;
  final TextEditingController searchController = TextEditingController();
  List<TransactionTrendModel> trendFiltered = [];

  // Static chart data
  List<TransactionTrendModel> staticTrendData = [];
  Map<String, double> staticMonthlyCredits = {};
  Map<String, double> staticMonthlyDebits = {};

  Map<String, double> monthlyCredits = {};
  Map<String, double> monthlyDebits = {};
  String accountCurrency = '';

  // ---------------- Chip management ----------------
  List<String> chips = [];
  Map<String, dynamic> activeFilters = {};

  void _applyFiltersFromSheet(FilterValues filter) {
    Map<String, dynamic> newFilters = {};

    // Only add chips for filters actually applied
    if (filter.creditDebit != 'All') newFilters['Credit/Debit'] = filter.creditDebit;
    if (filter.transactionType != 'All') newFilters['TransactionType'] = filter.transactionType;
    if (filter.categories.isNotEmpty) newFilters['Categories'] = List.from(filter.categories);
    if (filter.minAmount > 0 || filter.maxAmount < 1000000000) {
      newFilters['Amount'] = '${filter.minAmount.toInt()}-${filter.maxAmount.toInt()}';
    }
    Widget _apzChip(BuildContext context, String label, {bool selected = false, VoidCallback? onDelete}) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 48),
    
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
         color: AppColors.cardBackground(context), // new background color
        borderRadius: BorderRadius.circular(32), 
        
        border: Border.all(
          color: selected ? AppColors.primary(context) : Colors.grey.withOpacity(0.3),
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ApzText(
            label: label,
            fontSize: 13,
            color: selected ? AppColors.primary(context) : AppColors.primary_text(context),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.close, size: 16, color: AppColors.primary_text(context).withOpacity(0.7)),
            ),
          ],
        ],
      ),
    ),
  );
}

// Custom filter chip widget
Widget _filterChip(String type, String label) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 32),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: AppColors.primary(context),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ApzText(
              label: label,
              fontSize: 13,
              color: AppColors.primary_text(context),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeFilter(label),
            child: Icon(
              Icons.close,
              size: 16,
              color: AppColors.primary_text(context).withOpacity(0.7),
            ),
          ),
        ],
      ),
    ),
  );
}

    setState(() {
      activeFilters = newFilters;
      chips = newFilters.entries.expand((entry) {
        if (entry.key == 'Categories' && entry.value is List) {
          return List<String>.from(entry.value);
        } else {
          return [entry.value.toString()];
        }
      }).toList();
    });

    _applyFilters(
      creditDebit: filter.creditDebit,
      transactionType: filter.transactionType,
      minAmount: filter.minAmount,
      maxAmount: filter.maxAmount,
      categories: filter.categories,
    );
  }
  Widget _filterChip(String type, String label) {
  return Chip(
    label: Text(label),
    onDeleted: () => _removeFilter(label),
    deleteIcon: const Icon(Icons.close, size: 16),
  );
}


  // Remove individual filter by chip
void _removeFilter(String chip) {
  setState(() {
    activeFilters.forEach((key, value) {
      if (value is List && value.contains(chip)) {
        value.remove(chip);
      } else if (value == chip) {
        activeFilters.remove(key);
      }
    });

    // Rebuild chips list
    chips = activeFilters.entries.expand((entry) {
      final value = entry.value;
      if (value is List<String>) {
        return value;
      } else {
        return [value.toString()];
      }
    }).toList();
  });

  _applyFilters(); // optional: re-apply filtering logic
}

  void _clearAllFilters() {
    searchController.clear();
    setState(() {
      chips = [];
      activeFilters = {};
    });
    _applyFilters();
  }

FilterConfig? _cachedFilterConfig;
  @override
  void initState() {
    super.initState();
    loadAccountStatements();
    loadFilterConfig().then((config) => _cachedFilterConfig = config);
  }

  @override
  void didUpdateWidget(covariant TransactionsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.account.accountNo != widget.account.accountNo) {
      _clearAllFilters();
      loadAccountStatements();
    }
  }

  Future<FilterConfig> loadFilterConfig() async {
    final jsonStr = await rootBundle.loadString('mock/Dashboard/filters_mock.json');
    final data = json.decode(jsonStr);
    return FilterConfig.fromApi(data);
  }

  Future<void> loadAccountStatements() async {
    final String jsonString = await rootBundle.loadString('mock/Dashboard/accountstatement_mock.json');
    final data = json.decode(jsonString);

    List statements = data['apiResponse']['ResponseBody']['responseObj']['transactionDetails'] ?? [];
    allStatements = statements.map((e) => AccountStatementModel.fromJson(e)).toList();

    selectedStatement = allStatements.firstWhere(
      (statement) => statement.accountNo.replaceAll(' ', '') == widget.account.accountNo.replaceAll(' ', ''),
      orElse: () => AccountStatementModel(accountNo: '', trend: []),
    );

    trendFiltered = selectedStatement?.trend ?? [];
    staticTrendData = List.from(selectedStatement?.trend ?? []);
    if (trendFiltered.isNotEmpty) accountCurrency = trendFiltered.first.trnCcy ?? '';

    _initializeStaticChartData();
    _applyFilters();
  }

  void _initializeStaticChartData() {
    staticMonthlyCredits.clear();
    staticMonthlyDebits.clear();
    for (var trn in staticTrendData) {
      if (trn.trnDate != null && trn.trnDate!.isNotEmpty) {
        try {
          DateTime? date = DateTime.tryParse(trn.trnDate!);
          if (date == null) continue;
          String monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
          if ((trn.drcrIndicator ?? '') == 'CR') {
            staticMonthlyCredits[monthKey] = (staticMonthlyCredits[monthKey] ?? 0) + trn.trnAmount;
          } else {
            staticMonthlyDebits[monthKey] = (staticMonthlyDebits[monthKey] ?? 0) + trn.trnAmount;
          }
        } catch (e) {}
      }
    }
  }

  void _groupTransactionsByMonth() {
    monthlyCredits.clear();
    monthlyDebits.clear();
    for (var trn in trendFiltered) {
      if (trn.trnDate != null && trn.trnDate!.isNotEmpty) {
        try {
          DateTime? date = DateTime.tryParse(trn.trnDate!);
          if (date == null) continue;
          String monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
          if ((trn.drcrIndicator ?? '') == 'CR') {
            monthlyCredits[monthKey] = (monthlyCredits[monthKey] ?? 0) + trn.trnAmount;
          } else {
            monthlyDebits[monthKey] = (monthlyDebits[monthKey] ?? 0) + trn.trnAmount;
          }
        } catch (e) {}
      }
    }
  }

  void _applyFilters({
    DateTime? periodStart,
    DateTime? periodEnd,
    String? creditDebit,
    String? transactionType,
    double? minAmount,
    double? maxAmount,
    List<String>? categories,
  }) {
    if (selectedStatement == null || selectedStatement!.trend == null) {
      trendFiltered = [];
      if (mounted) setState(() {});
      return;
    }

    List<TransactionTrendModel> filtered = List.from(selectedStatement!.trend!);

    // Amount filter
    if (minAmount != null && maxAmount != null) {
      filtered = filtered.where((trn) => trn.trnAmount >= minAmount && trn.trnAmount <= maxAmount).toList();
    }

    // Credit/Debit filter
    if (creditDebit != null && creditDebit != 'All') {
      filtered = filtered.where((trn) => trn.drcrIndicator == (creditDebit == 'Credit' ? 'CR' : 'DR')).toList();
    }

    // Transaction type filter
    if (transactionType != null && transactionType != 'All') {
      filtered = filtered.where((trn) => trn.trnDesc?.toLowerCase().contains(transactionType.toLowerCase()) ?? false).toList();
    }

    // Categories filter
    if (categories != null && categories.isNotEmpty) {
      filtered = filtered.where((trn) => categories.contains(trn.trnDesc)).toList();
    }

    // Apply search filter
    if (searchController.text.isNotEmpty) {
      final searchText = searchController.text.toLowerCase();
      filtered = filtered.where((trn) {
        String formattedDate = '-';
        if (trn.trnDate != null && trn.trnDate!.isNotEmpty) {
          try {
            formattedDate = DateFormat('dd MMM yyyy').format(DateTime.parse(trn.trnDate!));
          } catch (_) {}
        }
        return (trn.trnDesc ?? '').toLowerCase().contains(searchText) ||
            (trn.trnRefNo ?? '').toLowerCase().contains(searchText) ||
            (trn.accountNo ?? '').toLowerCase().contains(searchText) ||
            (trn.creditAccount ?? '').toLowerCase().contains(searchText) ||
            formattedDate.toLowerCase().contains(searchText);
      }).toList();
    }

    trendFiltered = filtered;
    _groupTransactionsByMonth();

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _monthAbbreviation(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
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
    final allValues = [...staticMonthlyCredits.values, ...staticMonthlyDebits.values];
    if (allValues.isEmpty) return 10;
    final maxVal = allValues.reduce((a, b) => a > b ? a : b);
    return maxVal * 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final accountName = widget.account.acctName ?? 'Account';
    final last6Months = _getLast6Months();
    final maxY = _calculateMaxY();
    final yInterval = maxY / 3;
    final safeYInterval = (yInterval == 0 ? 1 : yInterval).toDouble();

    return Scaffold(
      body: Column(
        children: [
          
            ProfileHeaderWidget(
              title: 'Transactions',
              onBackPressed: () => Navigator.pop(context),
              trailingIcon: Icons.home,
              onActionPressed: () => Navigator.pop(context),
            ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Balance
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ApzText(
                          label: '${widget.account.currency} ${widget.account.availableBalance}',
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

                  // Chart
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
                            final credit = staticMonthlyCredits[key] ?? 0;
                            final debit = staticMonthlyDebits[key] ?? 0;
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(toY: credit, color: const Color(0xFFAAD0B2), width: 7, borderRadius: BorderRadius.circular(3)),
                                BarChartRodData(toY: debit, color: const Color(0xFFFFE0B2), width: 7, borderRadius: BorderRadius.circular(3)),
                              ],
                              barsSpace: 6,
                            );
                          }),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: safeYInterval, getTitlesWidget: (value, meta) {
                                return Text(value.toStringAsFixed(0), style: TextStyle(fontSize: 10, color: Colors.grey[500]));
                              }),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                                if (value.toInt() < 0 || value.toInt() >= last6Months.length) return const SizedBox();
                                final parts = last6Months[value.toInt()].split('-');
                                final month = int.parse(parts[1]);
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(_monthAbbreviation(month), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary_text(context))),
                                );
                              }),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            drawHorizontalLine: true,
                            horizontalInterval: safeYInterval,
                            getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade300.withOpacity(0.3), strokeWidth: 1),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),

                  // Search + Filter + Download
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ApzSearchBar(
                            type: AppzSearchBarType.primary,
                            placeholder: 'Search transactions',
                            controller: searchController,
                            items: selectedStatement?.trend ?? [],
                            trailingIcon: const Icon(Icons.tune, size: 20),
                     onTrailingPressed: () {
  if (_cachedFilterConfig == null) return; // Optional: show a loader if not ready

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FilterBottomSheet(
        config: _cachedFilterConfig!,
        initial: FilterValues(
          creditDebit: activeFilters['Credit/Debit'] ?? 'All',
          transactionType: activeFilters['TransactionType'] ?? 'All',
          minAmount: activeFilters['Amount'] != null
              ? double.parse(activeFilters['Amount'].split('-')[0])
              : 0,
          maxAmount: activeFilters['Amount'] != null
              ? double.parse(activeFilters['Amount'].split('-')[1])
              : 1000000000,
          categories: activeFilters['Categories'] != null
              ? List<String>.from(activeFilters['Categories'])
              : [],
        ),
        onApply: ({
          required creditDebit,
          required transactionType,
          required minAmount,
          required maxAmount,
          required categories,
        }) {
          final filter = FilterValues(
            creditDebit: creditDebit,
            transactionType: transactionType,
            minAmount: minAmount,
            maxAmount: maxAmount,
            categories: categories,
          );
          _applyFiltersFromSheet(filter);
        },
      );
    },
  );
},

                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground(context),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: IconButton(
                            onPressed: () => print("Download tapped"),
                            icon: Icon(Icons.file_download_rounded, color: AppColors.header_icon_color(context)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chips
                // Inside build() method, where chips are displayed
              if (chips.isNotEmpty)
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // same gap as bottom sheet
    child: Wrap(
      spacing: 12, // horizontal spacing between pills
      runSpacing: 12, // vertical spacing between lines
      children: activeFilters.entries.expand((entry) {
        final value = entry.value;
        if (value is List<String>) {
          return value.map((v) => _filterChip(entry.key, v));
        } else {
          return [_filterChip(entry.key, value.toString())];
        }
      }).toList(),
    ),
  ),

                  const SizedBox(height: 8),

                  // Transactions list
                  ...trendFiltered.take(15).map((trn) => TransactionCardWidget(trn: trn)).toList(),

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
          ),
        ],
      ),
    );
  }
}
