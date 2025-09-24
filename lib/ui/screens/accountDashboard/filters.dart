import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_text.dart';

class FilterValues {
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String creditDebit;
  final String transactionType;
  final double minAmount;
  final double maxAmount;
  final List<String> categories;

  const FilterValues({
    this.periodStart,
    this.periodEnd,
    this.creditDebit = 'All',
    this.transactionType = 'All',
    this.minAmount = 0,
    this.maxAmount = 1000000000,
    this.categories = const [],
  });
}

class FilterBottomSheet extends StatefulWidget {
  final FilterValues? initial;
  final void Function({
    DateTime? periodStart,
    DateTime? periodEnd,
    required String creditDebit,
    required String transactionType,
    required double minAmount,
    required double maxAmount,
    required List<String> categories,
  }) onApply;

  const FilterBottomSheet({super.key, this.initial, required this.onApply});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedCreditDebit = '';
  String selectedTransactionType = '';
  DateTimeRange? selectedDateRange;
  RangeValues amountRange = const RangeValues(0, 10000);
  final List<String> allCategories = const [
    'Cash',
    'Eating out',
    'Entertainment',
    'Expenses',
    'Family',
    'General',
    'Groceries',
    'Housing',
    'Investments',
    'Personal care',
    'Salary',
    'Savings'
  ];
  final Set<String> selectedCategories = <String>{};

  final creditDebitOptions = ['Credit', 'Debit'];
  final transactionOptions = [
    'ATM',
    'UPI',
    'IMPS',
    'RTGS',
    'NEFT',
    'POS',
    'Cheque payment',
    'Cash deposit',
    'Cash withdrawal',
    'Mobile Banking',
    'Online Banking'
  ];

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    if (i != null) {
      selectedCreditDebit = i.creditDebit == 'All' ? '' : i.creditDebit;
      selectedTransactionType =
          i.transactionType == 'All' ? '' : i.transactionType;
      if (i.periodStart != null && i.periodEnd != null) {
        selectedDateRange =
            DateTimeRange(start: i.periodStart!, end: i.periodEnd!);
      }
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

  // Local UI helpers
  Widget _pill(BuildContext context, String label, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFE0B2) : Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
            color: highlight
                ? const Color(0xFFFFE0B2)
                : Colors.white.withOpacity(0.1)),
      ),
      child:
          ApzText(label: label, fontSize: 13, color: const Color(0xFFE0E0E0)),
    );
  }

  Widget _segChip(BuildContext context, String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFE0B2) : Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
            color: selected
                ? const Color(0xFFFFE0B2)
                : Colors.white.withOpacity(0.1)),
      ),
      child:
          ApzText(label: label, fontSize: 13, color: const Color(0xFFE0E0E0)),
    );
  }

  Widget _categoryPill(BuildContext context, String label, bool selected) {
    return Container(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 12, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color:
                  selected ? const Color(0xFFFFE0B2) : const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(width: 16, height: 16),
          ),
          const SizedBox(width: 8),
          ApzText(label: label, fontSize: 13, color: const Color(0xFFE0E0E0)),
        ],
      ),
    );
  }

  Widget _periodChip(BuildContext context, String label, VoidCallback onTap,
      {bool highlight = false}) {
    return GestureDetector(
      onTap: onTap,
      child: _pill(context, label, highlight: highlight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.60,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
              decoration: const BoxDecoration(
                color: Color(0xFF212121),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white.withOpacity(0.10), width: 1),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const ApzText(
                            label: 'Filter transactions',
                            fontSize: 16,
                            color: Color(0xBFE0E0E0),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF3A3A3A),
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Amount range
                    const ApzText(
                        label: 'Amount range',
                        fontSize: 14,
                        color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RangeSlider(
                          values: amountRange,
                          min: 0,
                          max: 10000,
                          divisions: 100,
                          onChanged: (values) =>
                              setState(() => amountRange = values),
                          activeColor: const Color(0xFFFFE0B2),
                          inactiveColor:
                              const Color(0xFFFFE0B2).withOpacity(0.3),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ApzText(
                                  label: amountRange.start.toStringAsFixed(0),
                                  fontSize: 13,
                                  color: const Color(0xFFE0E0E0)),
                              ApzText(
                                  label: amountRange.end.toStringAsFixed(0),
                                  fontSize: 13,
                                  color: const Color(0xFFE0E0E0)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Period
                    const ApzText(
                        label: 'Period',
                        fontSize: 14,
                        color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _periodChip(context, 'Last 15 days', () {
                          final end = DateTime.now();
                          final start = end.subtract(const Duration(days: 15));
                          setState(() => selectedDateRange =
                              DateTimeRange(start: start, end: end));
                        }),
                        _periodChip(context, 'Last 30 days', () {
                          final end = DateTime.now();
                          final start = end.subtract(const Duration(days: 30));
                          setState(() => selectedDateRange =
                              DateTimeRange(start: start, end: end));
                        }, highlight: true),
                        _periodChip(context, 'Last 60 days', () {
                          final end = DateTime.now();
                          final start = end.subtract(const Duration(days: 60));
                          setState(() => selectedDateRange =
                              DateTimeRange(start: start, end: end));
                        }),
                        _periodChip(context, 'Last 90 days', () {
                          final end = DateTime.now();
                          final start = end.subtract(const Duration(days: 90));
                          setState(() => selectedDateRange =
                              DateTimeRange(start: start, end: end));
                        }),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              initialDateRange: selectedDateRange ??
                                  DateTimeRange(
                                    start: DateTime.now()
                                        .subtract(const Duration(days: 30)),
                                    end: DateTime.now(),
                                  ),
                            );
                            if (picked != null)
                              setState(() => selectedDateRange = picked);
                          },
                          child: _pill(context, 'Select Date Range'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Credit/Debit
                    const ApzText(
                        label: 'Credit/Debit',
                        fontSize: 14,
                        color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: creditDebitOptions.map((option) {
                        final isSelected = selectedCreditDebit == option;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedCreditDebit = option),
                          child: _segChip(context, option, isSelected),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Categories
                    const ApzText(
                        label: 'Categories',
                        fontSize: 14,
                        color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: allCategories.map((cat) {
                        final selected = selectedCategories.contains(cat);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                selectedCategories.remove(cat);
                              } else {
                                selectedCategories.add(cat);
                              }
                            });
                          },
                          child: _categoryPill(context, cat, selected),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Transaction type
                    const ApzText(
                        label: 'Transaction type',
                        fontSize: 14,
                        color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: transactionOptions.map((option) {
                        final isSelected = selectedTransactionType == option;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedTransactionType = option),
                          child: _pill(context, option, highlight: isSelected),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Footer
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF3A3A3A)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedCreditDebit = '';
                                selectedTransactionType = '';
                                selectedDateRange = null;
                                amountRange = const RangeValues(0, 10000);
                                selectedCategories.clear();
                              });
                            },
                            child: const ApzText(
                                label: 'Clear',
                                fontSize: 15,
                                color: Color(0xFFE0E0E0)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFE0B2),
                              foregroundColor: const Color(0xFF212121),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              final cd = selectedCreditDebit.isEmpty
                                  ? 'All'
                                  : selectedCreditDebit;
                              final tt = selectedTransactionType.isEmpty
                                  ? 'All'
                                  : selectedTransactionType;
                              widget.onApply(
                                periodStart: selectedDateRange?.start,
                                periodEnd: selectedDateRange?.end,
                                creditDebit: cd,
                                transactionType: tt,
                                minAmount: amountRange.start,
                                maxAmount: amountRange.end,
                                categories: selectedCategories.toList(),
                              );
                              Navigator.pop(context);
                            },
                            child: const ApzText(
                                label: 'Apply',
                                fontSize: 15,
                                color: Color(0xFF212121)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ));
  }
}
