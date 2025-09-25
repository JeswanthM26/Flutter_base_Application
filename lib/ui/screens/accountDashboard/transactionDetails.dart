import 'package:flutter/material.dart';
import 'package:retail_application/models/dashboard/accountstatement_model.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:retail_application/themes/apz_app_themes.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final TransactionTrendModel trn;

  const TransactionDetailsSheet({super.key, required this.trn});

  @override
  Widget build(BuildContext context) {
    void _showComingSoon() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const ApzText(label: 'Coming Soon', fontSize: 16),
          content: const ApzText(label: 'This feature is coming soon', fontSize: 14),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const ApzText(label: 'OK', fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // shrink to content height
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Transaction Amount
            ApzText(
              label: '${trn.trnCcy ?? ''} ${trn.trnAmount.toStringAsFixed(2)}',
              fontSize: 25,
            
              color: AppColors.primary_text(context),
            ),
            const SizedBox(height: 8),
            ApzText(
              label: '${_amountInWords(trn.trnAmount)} Only',
              fontSize: 13,
              color: AppColors.primary_text(context),
             
            ),
            const SizedBox(height: 16),

            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _categoryChip(context, 'Food & Drinks', Color(0xFF9FA8DA), _showComingSoon),
                const SizedBox(width: 8),
                _categoryChip(context, 'Pizza, Garlic Bread', Color(0xFF3A3A3A), _showComingSoon),
              ],
            ),
            const SizedBox(height: 16),

            // Raise Complaint
            GestureDetector(
              onTap: _showComingSoon,
              child: ApzText(
                label: 'Raise complaint',
                fontSize: 16,
                color: const Color(0xFFFFB4AB),
                
              ),
            ),
            const Divider(color: Colors.white24),

            // Description / Reference
            ApzText(
              label: '${trn.trnDesc ?? '-'}\nRef No: ${trn.trnRefNo ?? '-'}',
              fontSize: 13,
              color: AppColors.primary_text(context),
              
            ),
            const Divider(color: Colors.white24),

            // From Account
            _accountRow(context, 'From', trn.accountNo ?? '-', trn.accountNo ?? 'My Account', _showComingSoon),

            // To Account
            _accountRow(context, 'To', trn.creditAccount ?? '-', trn.creditAccount ?? 'Beneficiary', _showComingSoon),

            // Date
            _labelValueRow(context, 'Date', trn.trnDate ?? '-'),

            const SizedBox(height: 24),

            // Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: _actionButton(context, 'Split Transaction', Colors.transparent, AppColors.primary_text(context), _showComingSoon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(context, 'Share', const Color(0xFFFFE0B2), const Color(0xFF242426), _showComingSoon),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Category chip
  Widget _categoryChip(BuildContext context, String label, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ApzText(label: label, fontSize: 13, color: AppColors.primary_text(context)),
      ),
    );
  }

  // Account row
  Widget _accountRow(BuildContext context, String label, String maskedAcc, String name, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ApzText(label: label, fontSize: 13, color: AppColors.primary_text(context).withOpacity(0.75)),
            Row(
              children: [
                ApzText(label: name, fontSize: 13, color: AppColors.primary_text(context)),
                const SizedBox(width: 8),
                ApzText(label: maskedAcc, fontSize: 13, color: AppColors.primary_text(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Label-value row
  Widget _labelValueRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ApzText(label: label, fontSize: 13, color: AppColors.primary_text(context).withOpacity(0.75)),
          ApzText(label: value, fontSize: 13, color: AppColors.primary_text(context)),
        ],
      ),
    );
  }

  // Bottom button
  Widget _actionButton(BuildContext context, String label, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(32),
          border: bgColor == Colors.transparent ? Border.all(color: AppColors.primary_text(context), width: 1) : null,
        ),
        child: Center(
          child: ApzText(label: label, fontSize: 15,  color: textColor),
        ),
      ),
    );
  }

  // Convert amount to words (simple placeholder)
  String _amountInWords(double amount) {
    return 'Rupees ${amount.toStringAsFixed(0)}';
  }
}
