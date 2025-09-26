import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:retail_application/models/filters_model.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:retail_application/themes/apz_app_themes.dart';

// -------------------- Filter Values --------------------
class FilterValues {
  final String creditDebit;
  final String transactionType;
  final double minAmount;
  final double maxAmount;
  final List<String> categories;

  const FilterValues({
    this.creditDebit = 'All',
    this.transactionType = 'All',
    this.minAmount = 0,
    this.maxAmount = 1000000000,
    this.categories = const [],
  });
}

// -------------------- Filter Bottom Sheet --------------------
class FilterBottomSheet extends StatefulWidget {
  final FilterConfig config;
  final FilterValues? initial;
  final void Function({
    required String creditDebit,
    required String transactionType,
    required double minAmount,
    required double maxAmount,
    required List<String> categories,
  }) onApply;

  const FilterBottomSheet({
    super.key,
    required this.config,
    this.initial,
    required this.onApply,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

// -------------------- Icon helper --------------------
IconData getIconFromName(String? iconName) {
  if (iconName == null) return Icons.help_outline;
  const iconMap = {
    'attach_money': Icons.attach_money,
    'restaurant': Icons.restaurant,
    'movie': Icons.movie,
    'receipt_long': Icons.receipt_long,
    'family_restroom': Icons.family_restroom,
    'category': Icons.category,
    'shopping_bag': Icons.shopping_bag,
    'home': Icons.home,
    'show_chart': Icons.show_chart,
    'spa': Icons.spa,
    'monetization_on': Icons.monetization_on,
    'savings': Icons.savings,
    'arrow_downward': Icons.arrow_downward,
    'arrow_upward': Icons.arrow_upward,
    'atm': Icons.atm,
    'payments': Icons.payments,
    'sync_alt': Icons.sync_alt,
    'account_balance': Icons.account_balance,
    'send': Icons.send,
    'point_of_sale': Icons.point_of_sale,
    'description': Icons.description,
    'money_off': Icons.money_off,
    'smartphone': Icons.smartphone,
    'language': Icons.language,
    'date_range': Icons.date_range,
  };
  return iconMap[iconName] ?? Icons.help_outline;
}

// -------------------- State --------------------
class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedCreditDebit = '';
  String selectedTransactionType = '';
  RangeValues amountRange = const RangeValues(0, 10000);
  final Set<String> selectedCategories = <String>{};

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    if (i != null) {
      selectedCreditDebit = i.creditDebit == 'All' ? '' : i.creditDebit;
      selectedTransactionType = i.transactionType == 'All' ? '' : i.transactionType;
      final min = i.minAmount;
      final max = i.maxAmount < i.minAmount ? i.minAmount : i.maxAmount;
      amountRange = RangeValues(
        min.clamp(0, 10000).toDouble(),
        max.clamp(0, 10000).toDouble(),
      );
      selectedCategories
        ..clear()
        ..addAll(i.categories);
    }
  }

  // -------------------- Widgets --------------------
  Widget _pill(BuildContext context, String label, {bool highlight = false}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 48),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: highlight ? AppColors.primary(context).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: highlight ? AppColors.primary(context) : Colors.grey.withOpacity(0.3),
            width: highlight ? 2 : 1,
          ),
        ),
        child: ApzText(
          label: label,
          fontSize: 13,
          color: highlight ? AppColors.primary(context) : AppColors.primary_text(context),
        ),
      ),
    );
  }

Widget _segChip(BuildContext context, String label, bool selected) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 48),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary(context).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: selected ? AppColors.primary(context) : Colors.grey.withOpacity(0.3),
          width: selected ? 2 : 1,
        ),
      ),
      child: ApzText(
        label: label,
        fontSize: 13,
        color: selected ? AppColors.primary(context) : AppColors.primary_text(context),
      ),
    ),
  );
}

  Widget _categoryPill(BuildContext context, FilterItem item, bool selected) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 48),
      child: Container(
        padding: const EdgeInsets.only(top: 4, left: 4, right: 12, bottom: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary(context).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: selected ? AppColors.primary(context) : Colors.grey.withOpacity(0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(getIconFromName(item.icon),
                  size: 16,
                  color: selected ? AppColors.primary(context) : AppColors.primary_text(context)),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: ApzText(
                label: item.label,
                fontSize: 13,
                color: selected ? AppColors.primary(context) : AppColors.primary_text(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- Build --------------------
  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ApzText(
                        label: 'Filter transactions',
                        fontSize: 16,
                        color: AppColors.primary_text(context),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFF3A3A3A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Amount Range
                ApzText(label: 'Amount range', fontSize: 14, color: AppColors.primary_text(context)),
                const SizedBox(height: 16),
                RangeSlider(
                  values: amountRange,
                  min: 0,
                  max: 10000,
                  divisions: 100,
                  onChanged: (values) => setState(() => amountRange = values),
                  activeColor: AppColors.primary(context),
                  inactiveColor: AppColors.primary(context).withOpacity(0.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ApzText(label: amountRange.start.toStringAsFixed(0), fontSize: 13, color: AppColors.primary_text(context)),
                      ApzText(label: amountRange.end.toStringAsFixed(0), fontSize: 13, color: AppColors.primary_text(context)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Credit/Debit
                ApzText(label: 'Credit/Debit', fontSize: 14, color: AppColors.primary_text(context)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: config.creditDebitOptions.map((option) {
                    final isSelected = selectedCreditDebit == option.label;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCreditDebit = option.label),
                      child: _segChip(context, option.label, isSelected),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Categories
                ApzText(label: 'Categories', fontSize: 14, color: AppColors.primary_text(context)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: config.categories.map((cat) {
                    final selected = selectedCategories.contains(cat.label);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selected) {
                            selectedCategories.remove(cat.label);
                          } else {
                            selectedCategories.add(cat.label);
                          }
                        });
                      },
                      child: _categoryPill(context, cat, selected),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Transaction Type
                ApzText(label: 'Transaction type', fontSize: 14, color: AppColors.primary_text(context)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: config.transactionTypes.map((option) {
                    final isSelected = selectedTransactionType == option.label;
                    return GestureDetector(
                      onTap: () => setState(() => selectedTransactionType = option.label),
                      child: _pill(context, option.label, highlight: isSelected),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32), // extra space before footer

                // Footer Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedCreditDebit = '';
                            selectedTransactionType = '';
                            amountRange = const RangeValues(0, 10000);
                            selectedCategories.clear();
                          });
                          widget.onApply(
                            creditDebit: 'All',
                            transactionType: 'All',
                            minAmount: 0,
                            maxAmount: 10000,
                            categories: [],
                          );
                          Navigator.pop(context);
                        },
                        child: ApzText(label: 'Clear', fontSize: 15, color: AppColors.primary_text(context)),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary(context),
                          foregroundColor: AppColors.primary_text(context),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          final cd = selectedCreditDebit.isEmpty ? 'All' : selectedCreditDebit;
                          final tt = selectedTransactionType.isEmpty ? 'All' : selectedTransactionType;
                          widget.onApply(
                            creditDebit: cd,
                            transactionType: tt,
                            minAmount: amountRange.start,
                            maxAmount: amountRange.end,
                            categories: selectedCategories.toList(),
                          );
                          Navigator.pop(context);
                        },
                        child: ApzText(label: 'Apply', fontSize: 15, color: AppColors.primary_text(context)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------- Load JSON helper --------------------
Future<FilterConfig> loadFilterConfig() async {
  final jsonStr = await rootBundle.loadString('mock/Dashboard/filters_mock.json');
  final data = json.decode(jsonStr);
  final filtersJson = data["apiResponse"]["ResponseBody"]["responseObj"]["filters"];
  return FilterConfig.fromJson(filtersJson);
}
