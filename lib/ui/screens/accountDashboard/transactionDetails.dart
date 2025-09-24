import 'package:flutter/material.dart';
import 'package:retail_application/models/dashboard/accountstatement_model.dart';
import 'package:retail_application/ui/components/apz_text.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final TransactionTrendModel trn;

  const TransactionDetailsSheet({super.key, required this.trn});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF212121),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ApzText(
                        label: 'Transaction details',
                        fontSize: 16,
                        color: Color(0xFFE0E0E0)),
                  ],
                ),
                const SizedBox(height: 16),
                _detailRow('Date', trn.trnDate ?? '-'),
                _detailRow('Description', trn.trnDesc ?? '-'),
                _detailRow('Reference No', trn.trnRefNo ?? '-'),
                _detailRow('Type', trn.drcrIndicator ?? '-'),
                _detailRow('Amount',
                    '${trn.trnAmount.toStringAsFixed(2)} ${trn.trnCcy ?? ''}'),
                _detailRow(
                    'Running Balance', trn.runningBalance.toStringAsFixed(2)),
                _detailRow('Account No', trn.accountNo ?? '-'),
                _detailRow('Credit Account', trn.creditAccount ?? '-'),
                _detailRow(
                    'Currencies',
                    [
                      trn.trnCcy,
                      trn.accountCcy,
                      trn.creditAccountCcy,
                      trn.debAccountCcy
                    ]
                        .whereType<String>()
                        .where((s) => s.isNotEmpty)
                        .join(' / ')),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: ApzText(
                label: label, fontSize: 12, color: const Color(0xFFBDBDBD)),
          ),
          Expanded(
            child: ApzText(
                label: value, fontSize: 13, color: const Color(0xFFE0E0E0)),
          ),
        ],
      ),
    );
  }
}
