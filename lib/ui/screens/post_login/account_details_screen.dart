import 'package:flutter/material.dart';
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/ui/screens/post_login/profile_screen.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:Retail_Application/ui/components/apz_toogle_switch.dart';
 
class AccountDetailsScreen extends StatefulWidget {
  final AccountModel? account;
 
  const AccountDetailsScreen({super.key, this.account});
 
  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}
 
class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  // Toggle controllers
  final ApzToggleController creditController = ApzToggleController(true);
  final ApzToggleController debitController = ApzToggleController(false);
 
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
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Nickname Section
                  _buildNicknameSection(acc),
                  const SizedBox(height: 16),
 
                  /// Account Info
                  _buildAccountInfoSection(acc),
                  const SizedBox(height: 16),
 
                  /// Enable/Disable Transactions
                  _buildTransactionToggles(),
                  const SizedBox(height: 16),
 
                  /// Manage Limits
                  _buildManageLimits(),
                  const SizedBox(height: 16),
 
                  /// Close Account
                  _buildCloseAccount(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildNicknameSection(AccountModel? acc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Nickname",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.primary_text(context),
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
              Icon(Icons.favorite, color: AppColors.primary_text(context)),
              const SizedBox(width: 8),
              Expanded(
                child: ApzText(
                  label: acc?.nickName ?? acc?.acctName ?? "-",
                  fontWeight: ApzFontWeight.bodyMedium,
                  fontSize: 13,
                  color: AppColors.primary_text(context),
                ),
              ),
              Icon(Icons.more_vert, color: AppColors.primary_text(context)),
            ],
          ),
        ),
      ],
    );
  }
 
  Widget _buildAccountInfoSection(AccountModel? acc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Account information",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.primary_text(context),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _infoRow("A/c holder", acc?.customerName ?? "-"),
              _infoRow("A/c type", acc?.accountType ?? "-"),
              _infoRow("A/c number", acc?.accountNo ?? "-"),
              _infoRow("IFSC", "-"),
              _infoRow("Branch", "-"),
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
              color: AppColors.primary_text(context),
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
 
  Widget _buildTransactionToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Enable/Disable transactions",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.primary_text(context),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ApzToggleButton(
                label: "Credit transactions",
                controller: creditController,
                size: ApzToggleSize.large,
                isDisabled: false,
                onChanged: (value) {
                  debugPrint("Credit transactions toggled: $value");
                },
              ),
              Divider(
                color: AppColors.dashboardSavingsDividerColor(context),
                height: 1,
              ),
              ApzToggleButton(
                label: "Debit transactions",
                controller: debitController,
                size: ApzToggleSize.large,
                isDisabled: false,
                onChanged: (value) {
                  debugPrint("Debit transactions toggled: $value");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
 
  Widget _buildManageLimits() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.settings, color: AppColors.primary_text(context)),
          const SizedBox(width: 12),
          Expanded(
            child: ApzText(
              label: "Manage your limits",
              fontWeight: ApzFontWeight.bodyMedium,
              fontSize: 13,
              color: AppColors.primary_text(context),
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.primary_text(context)),
        ],
      ),
    );
  }
 
  Widget _buildCloseAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ApzText(
          label: "Close account",
          fontWeight: ApzFontWeight.bodyMedium,
          fontSize: 13,
          color: AppColors.primary_text(context),
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
 
 