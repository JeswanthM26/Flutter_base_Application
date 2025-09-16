import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/ui/components/apz_searchbar.dart';
import '../../models/dashboard/account_dashboard_promotions_model.dart';

// ---------------- PAYMENT CARD ----------------
enum PaymentCardActionType { text, icon }

class PaymentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final PaymentCardActionType actionType;
  final VoidCallback? onTap;
  final String? imageUrl;

  const PaymentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.actionType,
    this.onTap,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (imageUrl != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (imageUrl != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCredit ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- ACCOUNT ITEM CARD ----------------
class AccountItemCard extends StatelessWidget {
  final String title;
  final AccountModel account;
  final bool isCredit;

  const AccountItemCard({super.key, required this.title, required this.account, required this.isCredit});

  @override
  Widget build(BuildContext context) {
    final accNumber = account.accountNo.isNotEmpty ? account.accountNo : '----';
    final balance = (double.tryParse(account.availableBalance) ?? 0.0).toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: PaymentCard(
        title: title,
        subtitle: 'Account: $accNumber',
        amount: '₹ $balance',
        isCredit: isCredit,
        actionType: PaymentCardActionType.text,
        imageUrl: "assets/accountdashboard/Building Blocks.png",
      ),
    );
  }
}

// ---------------- CARD WIDGETS ----------------
class SavingsCard extends StatelessWidget {
  final bool hideBalance;
  final VoidCallback onToggleHide;
  final double totalBalance;
  final int totalAccounts;

  const SavingsCard({
    super.key,
    required this.hideBalance,
    required this.onToggleHide,
    required this.totalBalance,
    required this.totalAccounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 311,
      height: 104,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.56, 0.51),
          end: Alignment(1.57, 0.51),
          colors: [
            Color(0xFFFFCB55),
            Color(0xFFFFCB55),
            Color(0xFFFFE5AB),
            Color(0xFFFDFDFD),
            Color(0xFFFFE1A0),
            Color(0x06FFCB55),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalAccounts',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Savings & Current',
                  style: const TextStyle(
                    color: Color(0xFF242426),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggleHide,
                child: Icon(
                  hideBalance ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: const Color(0xFF242426),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Total Balance',
            style: TextStyle(
              color: Color(0x993C3C43),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hideBalance ? '***' : '₹ ${totalBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF242426),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class DepositCard extends StatelessWidget {
  final bool hideBalance;
  final VoidCallback onToggleHide;
  final List<AccountModel> depositAccounts;
  final String depositType;
  final int totalAccounts;

  const DepositCard({
    super.key,
    required this.hideBalance,
    required this.onToggleHide,
    required this.depositAccounts,
    required this.depositType,
    required this.totalAccounts,
  });

  @override
  Widget build(BuildContext context) {
    final filteredDeposits = depositAccounts.where((acc) {
      return depositType == "Fixed" ? acc.accountType == "FD" : acc.accountType == "RD";
    }).toList();

    double totalDeposits = filteredDeposits.fold(
      0.0,
      (sum, acc) => sum + (double.tryParse(acc.availableBalance) ?? 0.0),
    );

    return Container(
      width: 311,
      height: 104,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.42, 0.51),
          end: Alignment(1.76, 0.51),
          colors: [
            Color(0xFFB3E0FF),
            Color(0xFFFDFDFD),
            Color(0xFFB3E0FF),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalAccounts',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  depositType == "Fixed" ? 'Fixed Deposits' : 'Recurring Deposits',
                  style: const TextStyle(
                    color: Color(0xFF242426),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggleHide,
                child: Icon(
                  hideBalance ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: const Color(0xFF242426),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Total ${depositType == "Fixed" ? 'FD' : 'RD'}',
            style: TextStyle(
              color: const Color(0xFF242426).withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hideBalance ? '***' : '₹ ${totalDeposits.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFF242426),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class LoanCard extends StatelessWidget {
  final int totalAccounts;

  const LoanCard({super.key, required this.totalAccounts});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 311,
      height: 104,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.56, 0.51),
          end: Alignment(1.57, 0.51),
          colors: [
            Color(0xFFFFB3B3),
            Color(0xFFFFE0E0),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalAccounts',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Loans',
                  style: TextStyle(
                    color: Color(0xFF242426),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Total Loan Accounts',
            style: TextStyle(
              color: Color(0x993C3C43),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- ACCOUNT DASHBOARD ----------------
class AccountDashboard extends StatefulWidget {
  const AccountDashboard({super.key});

  @override
  State<AccountDashboard> createState() => _AccountDashboardState();
}

class _AccountDashboardState extends State<AccountDashboard> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int selectedIndex = 0;
  String depositType = "Fixed";

  bool hideSavings = false;
  bool hideDeposit = false;

  List<AccountModel> accounts = [];
  double savingsCurrentTotal = 0.0;
  List<AccountModel> accountsSavingsCurrent = [];
  List<AccountModel> accountsDeposits = [];
  List<AccountModel> accountsLoans = [];

  List<AccountDashboardPromotion> accountDashboardPromotions = [];

  @override
  void initState() {
    super.initState();
    loadAccounts();
    loadAccountDashboardPromotions();
  }

  Future<void> loadAccounts() async {
    final jsonStr = await rootBundle.loadString("mock/Dashboard/account_mock.json");
    final data = json.decode(jsonStr);

    final List<dynamic> accJson =
        data["apiResponse"]["ResponseBody"]["responseObj"]["accountDetails"];

    accounts = accJson.map((e) => AccountModel.fromJson(e)).toList();

    if (accounts.isNotEmpty) {
      final customerId = accounts.first.customerId;

      accountsSavingsCurrent = accounts
          .where((a) => a.customerId == customerId && (a.accountType == "SB" || a.accountType == "CA"))
          .toList();

      accountsDeposits = accounts
          .where((a) => a.customerId == customerId && (a.accountType == "FD" || a.accountType == "RD"))
          .toList();

      accountsLoans = accounts
          .where((a) => a.customerId == customerId && a.accountType == "LN")
          .toList();

      savingsCurrentTotal = accountsSavingsCurrent.fold(
        0.0,
        (sum, acc) => sum + (double.tryParse(acc.availableBalance) ?? 0.0),
      );
    }

    setState(() {});
  }

  Future<void> loadAccountDashboardPromotions() async {
    final jsonStr = await rootBundle.loadString("mock/Dashboard/accountdashboard_promotions.json");
    final data = json.decode(jsonStr);
    accountDashboardPromotions = AccountDashboardPromotion.listFromApi(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentPromotion = (selectedIndex < accountDashboardPromotions.length)
        ? accountDashboardPromotions[selectedIndex]
        : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // PageView for cards
          SizedBox(
            height: 140,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => selectedIndex = index);
              },
              children: [
                SavingsCard(
                  hideBalance: hideSavings,
                  onToggleHide: () => setState(() => hideSavings = !hideSavings),
                  totalBalance: savingsCurrentTotal,
                  totalAccounts: accountsSavingsCurrent.length,
                ),
                DepositCard(
                  hideBalance: hideDeposit,
                  onToggleHide: () => setState(() => hideDeposit = !hideDeposit),
                  depositAccounts: accountsDeposits,
                  depositType: depositType,
                  totalAccounts: accountsDeposits.length,
                ),
                LoanCard(
                  totalAccounts: accountsLoans.length,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ApzSearchBar(
              type: AppzSearchBarType.primary,
              placeholder: "Search here...",
              onChanged: (val) => debugPrint("Search input: $val"),
            ),
          ),

          const SizedBox(height: 16),

          // Conditional UI below PageView
          if (selectedIndex == 0) ...[
            _buildPaymentCardContainer(
              children: accountsSavingsCurrent
                  .map((acc) => AccountItemCard(
                        title: acc.accountType == 'CA' ? 'Current Account' : 'Savings Account',
                        account: acc,
                        isCredit: true,
                      ))
                  .toList(),
            ),
          ],
          if (selectedIndex == 1) ...[
            _buildDepositToggle(),
            const SizedBox(height: 12),
            _buildPaymentCardContainer(
              children: accountsDeposits
                  .where((acc) =>
                      depositType == "Fixed" ? acc.accountType == "FD" : acc.accountType == "RD")
                  .map((acc) => AccountItemCard(
                        title: acc.accountType == 'FD' ? 'Fixed Deposit' : 'Recurring Deposit',
                        account: acc,
                        isCredit: true,
                      ))
                  .toList(),
            ),
          ],
          if (selectedIndex == 2) ...[
            _buildPaymentCardContainer(
              children: accountsLoans
                  .map((acc) => AccountItemCard(
                        title: 'Loan${acc.loanType.isNotEmpty ? ' - ${acc.loanType}' : ''}',
                        account: acc,
                        isCredit: false,
                      ))
                  .toList(),
            ),
          ],

          if (currentPromotion != null) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                height: 343,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage(currentPromotion.image),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${currentPromotion.title}\n',
                                  style: const TextStyle(
                                    color: Color(0xFF0E2255),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: currentPromotion.subtitle,
                                  style: const TextStyle(
                                    color: Color(0xFF00ADC1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentPromotion.description,
                            style: const TextStyle(
                              color: Color(0xFF0E2255),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  // ---------------- PAYMENT CARD CONTAINER ----------------
  Widget _buildPaymentCardContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Background color for enclosing all payment cards
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDepositToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0x99353535),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0x597D7D84),
            ),
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => depositType = "Fixed"),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: depositType == "Fixed" ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Fixed',
                  style: TextStyle(
                    color: depositType == "Fixed" ? const Color(0xFF181818) : const Color(0xCCE0E0E0),
                    fontSize: 12,
                    fontWeight: depositType == "Fixed" ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => depositType = "Recurring"),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: depositType == "Recurring" ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Recurring',
                  style: TextStyle(
                    color: depositType == "Recurring" ? const Color(0xFF181818) : const Color(0xCCE0E0E0),
                    fontSize: 12,
                    fontWeight: depositType == "Recurring" ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
