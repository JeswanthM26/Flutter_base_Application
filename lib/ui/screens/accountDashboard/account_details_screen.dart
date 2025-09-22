import 'package:Retail_Application/ui/components/apz_alert.dart';
import 'package:Retail_Application/ui/screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for Clipboard
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:Retail_Application/ui/components/apz_toogle_switch.dart';

class AccountDetailsScreen extends StatefulWidget {
  final AccountModel account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  late final ApzToggleController creditController;
  late final ApzToggleController debitController;

  @override
  void initState() {
    super.initState();
    creditController = ApzToggleController(widget.account.creditAllowed == 'Y');
    debitController = ApzToggleController(widget.account.debitAllowed == 'N');

    creditController.addListener(() => setState(() {}));
    debitController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    creditController.dispose();
    debitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final acc = widget.account;

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: ProfileHeaderWidget(
              title: 'Account Details',
              onBackPressed: () => Navigator.pop(context),
              trailingIcon: Icons.home,
              onActionPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNicknameSection(acc),
                  const SizedBox(height: 16),
                  _buildAccountInfoSection(acc),
                  const SizedBox(height: 16),
                  _buildTransactionToggles(acc),
                  const SizedBox(height: 16),
                  _buildManageLimits(),
                  const SizedBox(height: 16),
                  _buildCloseAccount(), // left as-is
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection(AccountModel acc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Nickname",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.secondary_text(context),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.favorite_border_outlined,
                  color: AppColors.primary_text(context)),
              const SizedBox(width: 8),
              Expanded(
                child: ApzText(
                  label: " my Savings account",
                  fontWeight: ApzFontWeight.bodyMedium,
                  fontSize: 13,
                  color: AppColors.primary_text(context),
                ),
              ),
              Icon(Icons.edit, color: AppColors.primary_text(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfoSection(AccountModel acc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Account information",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.secondary_text(context),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _infoRow("A/c holder", acc.customerName),
              _infoRow("A/c type", acc.accountType),
              _infoRow("A/c number", acc.accountNo),
              _infoRow("IFSC", "-"),
              _infoRow("Branch", "-"),
              const SizedBox(height: 16),
              Row(
                children: [
                  _actionButton(
                    label: "Copy Info",
                    icon: Icons.copy,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: acc.accountNo));
                      ApzAlert.show(
                        context,
                        title: "Copied",
                        message: "Account number copied to clipboard",
                        messageType: ApzAlertMessageType.success,
                        buttons: ["OK"],
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _actionButton(
                    label: "Set as primary",
                    icon: Icons.star,
                    onTap: () {
                      ApzAlert.show(
                        context,
                        title: "Coming Soon",
                        message: "This feature is under development.",
                        messageType: ApzAlertMessageType.info,
                        buttons: ["OK"],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 109,
            child: ApzText(
              label: label,
              fontWeight: ApzFontWeight.bodyRegular,
              fontSize: 13,
              color: AppColors.secondary_text(context),
            ),
          ),
          Expanded(
            child: ApzText(
              label: value,
              fontWeight: ApzFontWeight.bodyMedium,
              fontSize: 13,
              color: AppColors.primary_text(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.transactionTagBackground(context),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.header_icon_color(context)),
            const SizedBox(width: 6),
            ApzText(
              label: label,
              fontWeight: ApzFontWeight.bodyMedium,
              fontSize: 13,
              color: AppColors.primary_text(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionToggles(AccountModel acc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Enable/Disable transactions",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.secondary_text(context),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: AppColors.cardBackground(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            children: [
              _buildToggleRow(
                label: "Credit transactions",
                toggleController: creditController,
                icon: Icons.arrow_upward,
              ),
              Divider(
                color: AppColors.secondary_text(context).withOpacity(0.3),
                height: 1,
              ),
              _buildToggleRow(
                label: "Debit transactions",
                toggleController: debitController,
                icon: Icons.arrow_downward,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow({
    required String label,
    required ApzToggleController toggleController,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Icon(icon, color: AppColors.header_icon_color(context)),
          const SizedBox(width: 16),
          Expanded(
            child: ApzToggleButton(
              label: label,
              controller: toggleController,
              size: ApzToggleSize.large,
              onChanged: (value) {
                setState(() {
                  toggleController.value = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageLimits() {
    return InkWell(
      onTap: () {
        ApzAlert.show(
          context,
          title: "Coming Soon",
          message: "This feature is under development.",
          messageType: ApzAlertMessageType.info,
          buttons: ["OK"],
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.cardBackground(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.settings, color: AppColors.header_icon_color(context)),
            const SizedBox(width: 12),
            Expanded(
              child: ApzText(
                label: "Manage your limits",
                fontWeight: ApzFontWeight.bodyMedium,
                fontSize: 13,
                color: AppColors.primary_text(context),
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.header_icon_color(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseAccount() {
    // left as-is
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Close account",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.secondary_text(context),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF513737),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.warning, color: const Color(0xFFF4ACA4)),
              const SizedBox(width: 12),
              Expanded(
                child: ApzText(
                  label: "Want to close this account?",
                  fontWeight: ApzFontWeight.bodyMedium,
                  fontSize: 13,
                  color: const Color(0xFFF4ACA4),
                ),
              ),
              Icon(Icons.chevron_right, color: const Color(0xFFF4ACA4)),
            ],
          ),
        ),
      ],
    );
  }
}
