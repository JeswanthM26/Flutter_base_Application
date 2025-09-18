import 'dart:convert';
import 'dart:ui';
import 'package:Retail_Application/models/dashboard/transaction_model.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, HapticFeedback;
import 'package:Retail_Application/ui/components/apz_payment.dart';
import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:intl/intl.dart';
import '../components/apz_alert.dart';

class RecentTransactions extends StatefulWidget {
  const RecentTransactions({super.key});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  List<Transaction> _transactions = [];
  int _highlightedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/transaction_mock.json');
    final jsonResult = json.decode(data);
    final list =
        jsonResult['apiResponse']['ResponseBody']['responseObj'] as List;

    setState(() {
      _transactions = list.map((e) => Transaction.fromJson(e)).toList();
    });
  }

  void _showTransactionModal(Transaction tx) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(child: TransactionModal(transaction: tx));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curved =
            CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
        return FadeTransition(
          opacity: anim1,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                    .animate(curved),
            child: ScaleTransition(scale: curved, child: child),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_transactions.isEmpty) {
      return Center(
        child: ApzText(
          label: "No Recent Transactions",
          fontWeight: ApzFontWeight.bodyMedium,
          color: AppColors.tertiary_text(context),
          fontSize: 14,
        ),
      );
    }

    final visibleTransactions = _transactions.take(5).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ApzText(
            label: "Recent Transactions",
            fontWeight: ApzFontWeight.labelRegular,
            color: AppColors.tertiary_text(context),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                ...List.generate(
                  visibleTransactions.length,
                  (index) {
                    final tx = visibleTransactions[index];
                    final bool isCredit = false;
                    bool isHighlighted = index == _highlightedIndex;

                    return Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onLongPress: () async {
                            HapticFeedback.mediumImpact();
                            setState(() => _highlightedIndex = index);
                            await Future.delayed(
                                const Duration(milliseconds: 750));
                            _showTransactionModal(tx);
                            setState(() => _highlightedIndex = -1);
                          },
                          child: AnimatedScale(
                            scale: isHighlighted ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: PaymentCard(
                                title: tx.nickName ?? tx.remarks,
                                subtitle: "${tx.txnDate} • ${tx.txnType}",
                                imageUrl: "assets/mock/person.png",
                                actionType: PaymentCardActionType.text,
                                amount:
                                    "${isCredit ? "+ " : "- "}${tx.txnCurrency} ${tx.txnAmount.toStringAsFixed(2)}",
                                isCredit: isCredit,
                              ),
                            ),
                          ),
                        ),
                        if (index != visibleTransactions.length - 1)
                          Divider(
                            color:
                                AppColors.dashboardSavingsDividerColor(context),
                            thickness: 1.0,
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 2),
                ApzButton(
                  label: 'See All',
                  appearance: ApzButtonAppearance.tertiary,
                  onPressed: () {
                    ApzAlert.show(
                      context,
                      title: "Coming Soon",
                      message: "The 'See All' feature is under development.",
                      messageType: ApzAlertMessageType.info,
                      buttons: ["OK"],
                      onButtonPressed: (btn) {
                        // Optional: handle button tap
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionModal extends StatelessWidget {
  final Transaction transaction;
  const TransactionModal({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool isSuccess = transaction.txnStatus.toLowerCase() == "suc";

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 343,
                      padding: const EdgeInsets.all(24),
                      decoration: ShapeDecoration(
                        color: AppColors.cardBackground(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.5),
                              ),
                              image: const DecorationImage(
                                image: AssetImage("assets/mock/person.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ApzText(
                            label:
                                "${transaction.txnCurrency} ${transaction.txnAmount.toStringAsFixed(2)}",
                            fontWeight: ApzFontWeight.headingSemibold,
                            color: AppColors.primary_text(context),
                            fontSize: 28,
                          ),
                          const SizedBox(height: 8),
                          ApzText(
                            label: transaction.nickName ?? transaction.remarks,
                            fontWeight: ApzFontWeight.bodyMedium,
                            color: AppColors.primary_text(context),
                            fontSize: 14,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 14,
                                  color: AppColors.tertiary_text(context)),
                              const SizedBox(width: 6),
                              ApzText(
                                label: _formatDate(transaction.txnDate),
                                fontWeight: ApzFontWeight.captionSemibold,
                                color: AppColors.primary_text(context),
                                fontSize: 12,
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                isSuccess ? Icons.check_circle : Icons.cancel,
                                size: 14,
                                color: isSuccess
                                    ? AppColors.semantic_sucess(context)
                                    : AppColors.semantic_error(context),
                              ),
                              const SizedBox(width: 4),
                              ApzText(
                                label: isSuccess ? "Completed" : "Failed",
                                fontWeight: ApzFontWeight.captionSemibold,
                                color: AppColors.primary_text(context),
                                fontSize: 12,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: ShapeDecoration(
                              color:
                                  AppColors.transactionTagBackground(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: ApzText(
                              label: transaction.txnType == "WIT"
                                  ? "Within Bank Transfer"
                                  : "${transaction.txnType} ",
                              fontWeight: ApzFontWeight.captionSemibold,
                              color: AppColors.primary_text(context),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Divider(
                            color:
                                AppColors.dashboardSavingsDividerColor(context),
                            thickness: 0.3,
                          ),
                          const SizedBox(height: 12),
                          Column(
                            children: [
                              _buildDetailRow(context, "Transaction ID",
                                  transaction.txnRefNo),
                              const SizedBox(height: 5),
                              _buildDetailRow(
                                  context, "From", transaction.debitAccNo),
                              const SizedBox(height: 5),
                              _buildDetailRow(
                                  context, "To", transaction.beneAcctNo),
                              const SizedBox(height: 5),
                              _buildDetailRow(
                                  context, "Purpose", transaction.remarks),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 343,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: "Raise Dispute",
                              icon: Icons.report,
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Raise Dispute clicked")),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: "Split Payment",
                              icon: Icons.call_split,
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Split Payment clicked")),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildActionButton(
                              context,
                              label: "Share",
                              icon: Icons.share,
                              onTap: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Share clicked")),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cardBackground(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 28, color: AppColors.primary_text(context)),
          ),
          const SizedBox(height: 6),
          Center(
            child: ApzText(
              label: label,
              fontWeight: ApzFontWeight.buttonTextMedium,
              color: AppColors.primary_text(context),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ApzText(
            label: label,
            fontWeight: ApzFontWeight.captionSemibold,
            color: AppColors.tertiary_text(context),
            fontSize: 12,
          ),
          ApzText(
            label: value,
            fontWeight: ApzFontWeight.bodyRegular,
            color: AppColors.primary_text(context),
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat("dd MMM ''yy").format(parsedDate);
    } catch (_) {
      return rawDate;
    }
  }
}
