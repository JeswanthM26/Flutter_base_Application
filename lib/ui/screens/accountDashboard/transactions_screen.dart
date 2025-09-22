import 'dart:convert';
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/dashboard/accountstatement_model.dart';
import 'package:Retail_Application/ui/components/apz_searchbar.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:Retail_Application/ui/screens/Profile/profile_screen.dart';

import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionsScreen extends StatefulWidget {
  final AccountModel account;

  const TransactionsScreen({super.key, required this.account});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<AccountStatementModel> allStatements = [];
  AccountStatementModel? selectedStatement;
  bool accountExists = false;

  // Search & filter
  final TextEditingController searchController = TextEditingController();
  List trendFiltered = [];
  String activeFilter = "All"; // default filter

  // Demo filter options
  final List<String> filters = [
    "All",
    "Amount (1K - 4K)",
    "Last 30 days",
    "Credit",
    "ATM"
  ];

  @override
  void initState() {
    super.initState();
    loadAccountStatements();
  }

  Future<void> loadAccountStatements() async {
    final String jsonString = await rootBundle
        .loadString('mock/Dashboard/accountstatement_mock.json');
    final data = json.decode(jsonString);

    List statements = data['apiResponse']['ResponseBody']['responseObj']
            ['transactionDetails'] ??
        [];
    allStatements =
        statements.map((e) => AccountStatementModel.fromJson(e)).toList();

    selectedStatement = allStatements.firstWhere(
      (statement) =>
          statement.accountNo.replaceAll(' ', '') ==
          widget.account.accountNo.replaceAll(' ', ''),
      orElse: () => AccountStatementModel(accountNo: '', trend: []),
    );

    accountExists =
        selectedStatement != null && selectedStatement!.accountNo.isNotEmpty;

    // Initially show all trend items
    trendFiltered = selectedStatement?.trend ?? [];

    setState(() {});
  }

  void _applyFilters() {
    List filtered = selectedStatement?.trend ?? [];

    // Apply search
    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where((trn) => trn.trnDesc
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    // Apply filter chip
    if (activeFilter != "All") {
      switch (activeFilter) {
        case "Amount (1K - 4K)":
          filtered = filtered
              .where((trn) =>
                  double.tryParse(trn.trnAmount ?? "0") != null &&
                  double.parse(trn.trnAmount) >= 1000 &&
                  double.parse(trn.trnAmount) <= 4000)
              .toList();
          break;
        case "Last 30 days":
          final now = DateTime.now();
          filtered = filtered
              .where((trn) =>
                  DateTime.tryParse(trn.trnDate ?? "") != null &&
                  now.difference(DateTime.parse(trn.trnDate!)).inDays <= 30)
              .toList();
          break;
        case "Credit":
          filtered =
              filtered.where((trn) => trn.drcrIndicator == "CR").toList();
          break;
        case "ATM":
          filtered = filtered
              .where((trn) => trn.trnDesc.toLowerCase().contains("atm"))
              .toList();
          break;
      }
    }

    setState(() {
      trendFiltered = filtered;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balance = (double.tryParse(widget.account.availableBalance) ?? 0.0)
        .toStringAsFixed(2);
    final accountName = widget.account.acctName ?? 'Account';

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: ProfileHeaderWidget(
              title: '${widget.account.accountType} Transactions',
              onBackPressed: () => Navigator.pop(context),
              trailingIcon: Icons.home,
              onActionPressed: () => Navigator.pop(context),
            ),
          ),

          // Balance Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApzText(
                  label: '₹$balance',
                  fontSize: 24,
                  fontWeight: ApzFontWeight.headingSemibold,
                  color: AppColors.primary_text(context),
                ),
                const SizedBox(height: 4),
                ApzText(
                  label: "$accountName's Account",
                  fontSize: 15,
                  fontWeight: ApzFontWeight.bodyRegular,
                  color: AppColors.primary_text(context),
                ),
                const SizedBox(height: 8),
                ApzText(
                  label: 'Account Exists: $accountExists',
                  fontSize: 16,
                  fontWeight: ApzFontWeight.bodyMedium,
                  color: AppColors.primary_text(context),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ApzSearchBar(
              type: AppzSearchBarType.primary,
              placeholder: 'Search transactions',
              controller: searchController,
              items: selectedStatement?.trend ?? [],
              labelSelector: (item) => item.trnDesc.toString(),
              onFiltered: (_) => _applyFilters(),
            ),
          ),

          const SizedBox(height: 8),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: filters.map((filter) {
                final isActive = filter == activeFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isActive,
                    onSelected: (_) {
                      setState(() {
                        activeFilter = filter;
                      });
                      _applyFilters();
                    },
                    selectedColor: AppColors.primary(context),
                    backgroundColor: AppColors.cardBackground(context),
                    labelStyle: TextStyle(
                      color: isActive
                          ? Colors.white
                          : AppColors.primary_text(context),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Transaction List
          Expanded(
            child: trendFiltered.isNotEmpty
                ? ListView.builder(
                    itemCount: trendFiltered.length,
                    itemBuilder: (context, index) {
                      final trn = trendFiltered[index];
                      return Card(
                        color: AppColors.cardBackground(context),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          title: ApzText(
                            label: trn.trnDesc,
                            fontSize: 16,
                            fontWeight: ApzFontWeight.bodyMedium,
                            color: AppColors.primary_text(context),
                          ),
                          subtitle: ApzText(
                            label:
                                'Date: ${trn.trnDate} | Amount: ${trn.trnAmount} ${trn.trnCcy}',
                            fontSize: 14,
                            fontWeight: ApzFontWeight.bodyRegular,
                            color: AppColors.primary_text(context),
                          ),
                          trailing: ApzText(
                            label: trn.drcrIndicator,
                            fontSize: 14,
                            fontWeight: ApzFontWeight.bodyMedium,
                            color: AppColors.primary_text(context),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
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
    );
  }
}
