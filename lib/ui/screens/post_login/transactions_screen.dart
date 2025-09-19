import 'dart:convert';
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/dashboard/transaction_model.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Retail_Application/ui/screens/post_login/profile_screen.dart';

class TransactionsScreen extends StatefulWidget {
  final AccountModel? account;
  const TransactionsScreen({super.key, this.account});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final data =
          await rootBundle.loadString('mock/Dashboard/transaction_mock.json');
      final jsonData = json.decode(data) as Map<String, dynamic>;
      final all = Transaction.listFromApi(jsonData);
      final acc = widget.account;
      List<Transaction> filtered = acc == null
          ? all
          : all
              .where((t) =>
                  t.debitAccNo == acc.accountNo ||
                  t.beneAcctNo == acc.accountNo)
              .toList();
      if (filtered.isEmpty) {
        // Fallback to all transactions if no match for the selected account in mock
        filtered = all;
      }
      setState(() {
        _transactions = filtered;
      });
    } catch (_) {
      setState(() {
        _transactions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final acc = widget.account;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: ProfileHeaderWidget(
              title: 'Transactions',
              onBackPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (acc != null) ...[
                    ApzText(
                      label:
                          '${acc.acctName ?? acc.nickName ?? acc.customerName} (${acc.accountNo})',
                      fontSize: 14,
                      fontWeight: ApzFontWeight.headingsMedium,
                      color: AppColors.primary_text(context),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _transactions.isEmpty
                          ? Center(
                              child: ApzText(
                                label: 'No transactions found',
                                fontSize: 14,
                                fontWeight: ApzFontWeight.bodyRegular,
                                color: AppColors.secondary_text(context),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final tx = _transactions[index];
                                final isCredit =
                                    (tx.txnType).toLowerCase().contains('cr');
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ApzText(
                                            label: tx.remarks,
                                            fontSize: 14,
                                            fontWeight:
                                                ApzFontWeight.bodyMedium,
                                            color:
                                                AppColors.primary_text(context),
                                          ),
                                          const SizedBox(height: 4),
                                          ApzText(
                                            label: tx.txnDate,
                                            fontSize: 12,
                                            fontWeight:
                                                ApzFontWeight.bodyRegular,
                                            color: AppColors.secondary_text(
                                                context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ApzText(
                                      label:
                                          '${tx.txnCurrency} ${tx.txnAmount.toStringAsFixed(2)}',
                                      fontSize: 14,
                                      fontWeight: ApzFontWeight.headingsMedium,
                                      color: isCredit
                                          ? AppColors.semantic_sucess(context)
                                          : AppColors.primary_text(context),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 16,
                                color: AppColors.dashboardSavingsDividerColor(
                                    context),
                              ),
                              itemCount: _transactions.length,
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
