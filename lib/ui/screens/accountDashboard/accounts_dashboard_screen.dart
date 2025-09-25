import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:retail_application/models/dashboard/account_dashboard_promotions_model.dart';
import 'package:retail_application/models/dashboard/account_model.dart';

import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/ui/components/apz_payment.dart';
import 'package:retail_application/ui/components/apz_payment.dart'
    as apz_payment;
import 'package:retail_application/ui/components/apz_searchbar.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:retail_application/ui/screens/Profile/profile_screen.dart';
import 'package:retail_application/ui/screens/accountDashboard/account_details_screen.dart';
import 'transactions_screen.dart';

// ---------------------- ACCOUNT ITEM CARD ----------------------
class AccountItemCard extends StatelessWidget {
  final String title;
  final AccountModel account;
  final bool isCredit;
  final VoidCallback? onViewDetails;
  final VoidCallback? onTap;

  const AccountItemCard({
    super.key,
    required this.title,
    required this.account,
    required this.isCredit,
    this.onViewDetails,
    this.onTap,
  });

  String _maskedAccountNumber(String accNo) {
    if (accNo.isEmpty) return '----';
    if (accNo.length <= 4) return '**$accNo';
    return '**${accNo.substring(accNo.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final maskedAccNo = _maskedAccountNumber(account.accountNo);
    final balance =
        (double.tryParse(account.availableBalance) ?? 0.0).toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Slidable(
          key: ValueKey(account.accountNo),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.35,
            children: [
              CustomSlidableAction(
                onPressed: (context) {
                  if (onViewDetails != null) {
                    onViewDetails!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountDetailsScreen(account: account),
                      ),
                    );
                  }
                },
                backgroundColor: AppColors.slidebuttonBackground(context),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'View',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: InkWell(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                  return;
                }
                if (account.accountType == 'SB' ||
                    account.accountType == 'CA') {
                  context.push('/transactions', extra: account);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountDetailsScreen(account: account),
                    ),
                  );
                }
              },
              child: PaymentCard(
                title: title,
                subtitle: maskedAccNo,
                imageUrl: "assets/mock/person.png",
                actionType: apz_payment.PaymentCardActionType.text,
                amount: '${account.currency} $balance',
                isCredit: isCredit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------- DASHBOARD CARD DATA ----------------------
class DashboardCardData {
  final String title;
  final String subtitle;
  final String amount;
  final Widget? smallImage;
  final bool showEye;
  final Gradient? backgroundGradient;
  final bool isDark;
  final int badgeCount;
  final double? cardWidth;

  DashboardCardData({
    required this.title,
    required this.subtitle,
    required this.amount,
    this.smallImage,
    this.showEye = false,
    this.backgroundGradient,
    this.isDark = false,
    this.badgeCount = 0,
    this.cardWidth,
  });
}

class DashboardCard extends StatelessWidget {
  final DashboardCardData data;
  final VoidCallback? onEyeTap;
  final bool forceBlackText;

  const DashboardCard({
    Key? key,
    required this.data,
    this.onEyeTap,
    this.forceBlackText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: data.cardWidth ?? 311,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: data.backgroundGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ApzText(
                label: data.title.toUpperCase(),
                fontSize: 13,
                fontWeight: ApzFontWeight.titlesSemibold,
                color: Colors.black,
              ),
              const SizedBox(width: 6),
              if (data.badgeCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: const Color(0x28787880),
                    borderRadius: BorderRadius.circular(555),
                  ),
                  child: ApzText(
                    label: data.badgeCount.toString(),
                    fontSize: 12,
                    fontWeight: ApzFontWeight.titlesSemibold,
                    color: const Color(0xFF171717),
                  ),
                ),
              const Spacer(),
              if (data.smallImage != null)
                SizedBox(width: 28, height: 28, child: data.smallImage!),
            ],
          ),
          const SizedBox(height: 12),
          ApzText(
            label: data.subtitle,
            fontSize: 12,
            fontWeight: ApzFontWeight.bodyMedium,
            color: Colors.black,
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ApzText(
                label: data.amount,
                fontSize: 14,
                fontWeight: ApzFontWeight.titlesSemibold,
                color: Colors.black,
              ),
              if (data.showEye)
                GestureDetector(
                  onTap: onEyeTap,
                  child: Icon(
                    data.showEye && data.amount == '***'
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------- CARD CAROUSEL ----------------------
class CardCarousel extends StatefulWidget {
  final List<DashboardCardData> cards;
  final ValueChanged<int>? onPageChanged;
  final Function(int)? onEyeTapForIndex;

  const CardCarousel({
    Key? key,
    required this.cards,
    this.onPageChanged,
    this.onEyeTapForIndex,
  }) : super(key: key);

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  late final PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.93);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 107,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.cards.length,
        onPageChanged: (index) {
          setState(() => currentIndex = index);
          if (widget.onPageChanged != null) widget.onPageChanged!(index);
        },
        itemBuilder: (context, index) {
          final cardData = widget.cards[index];
          return DashboardCard(
            data: cardData,
            onEyeTap: () {
              if (widget.onEyeTapForIndex != null) {
                widget.onEyeTapForIndex!(index);
              }
            },
          );
        },
      ),
    );
  }
}

// ---------------------- ACCOUNT DASHBOARD SCREEN ----------------------
class AccountDashboardScreen extends StatelessWidget {
  const AccountDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
            
             ProfileHeaderWidget(
              onBackPressed: () {
                Navigator.pop(context);
              },
              title: "All Accounts",
            ),
        
          Expanded(
            child: SingleChildScrollView(
              child: AccountDashboard(), // now content won't stretch
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------- ACCOUNT DASHBOARD WIDGET ----------------------
class AccountDashboard extends StatefulWidget {
  const AccountDashboard({super.key});

  @override
  State<AccountDashboard> createState() => _AccountDashboardState();
}

class _AccountDashboardState extends State<AccountDashboard> {
  int selectedIndex = 0;
  String depositType = "Fixed";
  bool hideSavings = false;
  bool hideDeposit = false;
  bool hideLoan = false;
  List<AccountModel> accounts = [];
  double savingsCurrentTotal = 0.0;
  List<AccountModel> accountsSavingsCurrent = [];
  List<AccountModel> accountsDeposits = [];
  List<AccountModel> accountsLoans = [];
  List<AccountDashboardPromotion> accountDashboardPromotions = [];

  // --- SEARCH RELATED ---
  TextEditingController searchController = TextEditingController();
  List<AccountModel> filteredSavings = [];
  List<AccountModel> filteredDeposits = [];
  List<AccountModel> filteredLoans = [];

  String _loanTypeLabel(String code) {
    switch (code) {
      case 'HL':
        return 'Home Loan';
      case 'CL':
        return 'Car Loan';
      case 'PL':
        return 'Personal Loan';
      case 'EL':
        return 'Education Loan';
      default:
        return code.isNotEmpty ? code : 'Loan';
    }
  }
    String _accountTypeLabel(AccountModel acc) {
    switch (acc.accountType) {
      case 'SB':
        return 'Savings Account';
      case 'CA':
        return 'Current Account';
      case 'FD':
        return 'Fixed Deposit';
      case 'RD':
        return 'Recurring Deposit';
      case 'LN':
        return 'Loan';
      default:
        return acc.accountType;
    }
  }

  bool _isFixedDeposit(AccountModel account) {
    return account.accountType == "FD" || account.loanType == "FD";
  }

  bool _isRecurringDeposit(AccountModel account) {
    return account.accountType == "RD" || account.loanType == "RD";
  }

  List<AccountModel> _depositsForSelectedType() {
    if (depositType == "Fixed") {
      return filteredDeposits.where(_isFixedDeposit).toList();
    } else {
      return filteredDeposits.where(_isRecurringDeposit).toList();
    }
  }

  String _currencyFor(List<AccountModel> list) {
    if (list.isNotEmpty && list.first.currency.isNotEmpty) {
      return list.first.currency;
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    loadAccounts();
    loadAccountDashboardPromotions();
  }

  Future<void> loadAccounts() async {
    final jsonStr =
        await rootBundle.loadString("mock/Dashboard/account_mock.json");
    final data = json.decode(jsonStr);
    final List<dynamic> accJson =
        data["apiResponse"]["ResponseBody"]["responseObj"]["accountDetails"];
    accounts = accJson.map((e) => AccountModel.fromJson(e)).toList();

    if (accounts.isNotEmpty) {
      final customerId = accounts.first.customerId;
      accountsSavingsCurrent = accounts
          .where((a) =>
              a.customerId == customerId &&
              (a.accountType == "SB" || a.accountType == "CA"))
          .toList();
      accountsDeposits = accounts
          .where((a) =>
              a.customerId == customerId &&
              (a.accountType == "FD" || a.accountType == "RD"))
          .toList();
      accountsLoans = accounts
          .where((a) => a.customerId == customerId && a.accountType == "LN")
          .toList();

      savingsCurrentTotal = accountsSavingsCurrent.fold(
        0.0,
        (sum, acc) => sum + (double.tryParse(acc.availableBalance) ?? 0.0),
      );

      filteredSavings = List.from(accountsSavingsCurrent);
      filteredDeposits = List.from(accountsDeposits);
      filteredLoans = List.from(accountsLoans);
    }
    setState(() {});
  }

  Future<void> loadAccountDashboardPromotions() async {
    final jsonStr = await rootBundle
        .loadString("mock/Dashboard/accountdashboard_promotions.json");
    final data = json.decode(jsonStr);
    accountDashboardPromotions = AccountDashboardPromotion.listFromApi(data);
    setState(() {});
  }

  void _applySearch(String query) {
    final q = query.toLowerCase();

   filteredSavings = accountsSavingsCurrent.where((acc) {
  final label = _accountTypeLabel(acc).toLowerCase();
  return acc.accountNo.toLowerCase().contains(q) || label.contains(q);
}).toList();


filteredDeposits = accountsDeposits.where((acc) {
  final label = _accountTypeLabel(acc).toLowerCase();
  return acc.accountNo.toLowerCase().contains(q) || label.contains(q);
}).toList();

filteredLoans = accountsLoans.where((acc) {
  final label = _accountTypeLabel(acc).toLowerCase();
  return acc.accountNo.toLowerCase().contains(q) || label.contains(q);
}).toList();


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const gradientSavings = LinearGradient(
      begin: Alignment(-0.56, 0.51),
      end: Alignment(1.57, 0.51),
      colors: [
        Color(0xFFFFD982),
        Color(0xFFFFE5AB),
        Color(0xFFFEFEFE),
        Color(0xFFFFE2A1),
      ],
    );
    const gradientDeposit = LinearGradient(
      begin: Alignment(-0.42, 0.51),
      end: Alignment(1.76, 0.51),
      colors: [
        Color(0xFFB3E0FF),
        Color(0xFFFDFDFD),
        Color(0xFFB3E0FF),
      ],
    );
    const gradientLoan = LinearGradient(
      begin: Alignment(-0.56, 0.51),
      end: Alignment(1.57, 0.51),
      colors: [
        Color(0xFFFFB3B3),
        Color(0xFFFFE0E0),
      ],
    );

    final loanTotal = accountsLoans.fold<double>(
      0.0,
      (sum, acc) => sum + (double.tryParse(acc.availableBalance) ?? 0.0),
    );

    final depositsSelected = _depositsForSelectedType();
    final depositsGrandTotal = accountsDeposits.fold<double>(
      0.0,
      (sum, acc) => sum + (double.tryParse(acc.availableBalance) ?? 0.0),
    );

    final carouselCards = <DashboardCardData>[
      DashboardCardData(
        title: 'Savings & Current',
        subtitle: 'Total Balance',
        amount: hideSavings
            ? '***'
            : '${_currencyFor(accountsSavingsCurrent)} ${savingsCurrentTotal.toStringAsFixed(2)}',
        smallImage: Image.asset('assets/accountdashboard/Building Blocks.png',
            fit: BoxFit.contain),
        showEye: true,
        backgroundGradient: gradientSavings,
        badgeCount: accountsSavingsCurrent.length,
        cardWidth: 420,
      ),
      DashboardCardData(
        title: 'Deposits',
        subtitle: 'Total Deposits',
        amount: hideDeposit
            ? '***'
            : '${_currencyFor(accountsDeposits)} ${depositsGrandTotal.toStringAsFixed(2)}',
        smallImage: Image.asset('assets/accountdashboard/Building Blocks.png',
            fit: BoxFit.contain),
        showEye: true,
        backgroundGradient: gradientDeposit,
        badgeCount: depositsSelected.length,
        cardWidth: 311,
      ),
      DashboardCardData(
        title: 'Loans',
        subtitle: 'Outstanding Balance',
        amount: hideLoan
            ? '***'
            : '${_currencyFor(accountsLoans)} ${loanTotal.toStringAsFixed(2)}',
        smallImage: Image.asset('assets/accountdashboard/Building Blocks.png',
            fit: BoxFit.contain),
        showEye: true,
        backgroundGradient: gradientLoan,
        badgeCount: accountsLoans.length,
        cardWidth: 380,
      ),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CardCarousel(
              cards: carouselCards,
              onPageChanged: (index) => setState(() => selectedIndex = index),
              onEyeTapForIndex: (index) {
                setState(() {
                  if (index == 0) hideSavings = !hideSavings;
                  if (index == 1) hideDeposit = !hideDeposit;
                  if (index == 2) hideLoan = !hideLoan;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ApzSearchBar(
              type: AppzSearchBarType.primary,
              trailingIcon: const Icon(Icons.mic),
              onTrailingPressed: () {},
              placeholder: "Search here...",
              controller: searchController,
              onChanged: (val) => _applySearch(val),
            ),
          ),
          const SizedBox(height: 16),

          // --- Savings & Current ---
          if (selectedIndex == 0)
            _buildPaymentCardContainer(
              children: filteredSavings
                  .map((acc) => AccountItemCard(
                        title: acc.accountType == 'CA'
                            ? 'Current Account'
                            : 'Savings Account',
                        account: acc,
                        isCredit: false,
                        onViewDetails: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AccountDetailsScreen(account: acc),
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TransactionsScreen(account: acc),
                          ),
                        ),
                      ))
                  .toList(),
            ),

          // --- Deposits ---
          // --- Deposits ---
          if (selectedIndex == 1) ...[
            _buildDepositToggle(),
            const SizedBox(height: 12),
            _buildPaymentCardContainer(
              children: _depositsForSelectedType()
                  .map((acc) => AccountItemCard(
                        title: acc.accountType == "FD"
                            ? "Fixed Deposit"
                            : "Recurring Deposit",
                        account: acc,
                        isCredit: false,
                        onViewDetails: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AccountDetailsScreen(account: acc),
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AccountDetailsScreen(account: acc),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],

          // --- Loans ---
          // --- Loans ---
          if (selectedIndex == 2)
            _buildPaymentCardContainer(
              children: filteredLoans
                  .map((acc) => AccountItemCard(
                        title:
                            _loanTypeLabel(acc.loanType), // 👈 use mapping here
                        account: acc,
                        isCredit: false,
                        onViewDetails: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AccountDetailsScreen(account: acc),
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AccountDetailsScreen(account: acc),
                          ),
                        ),
                      ))
                  .toList(),
            ),

          // --- Promotions ---
          if (selectedIndex < accountDashboardPromotions.length) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                height: 343,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        accountDashboardPromotions[selectedIndex].image),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ApzText(
                            label:
                                accountDashboardPromotions[selectedIndex].title,
                            fontSize: 18,
                            fontWeight: ApzFontWeight.headingsBold,
                            color: const Color(0xFF0E2255),
                          ),
                          const SizedBox(height: 5),
                          ApzText(
                            label: accountDashboardPromotions[selectedIndex]
                                .subtitle,
                            fontSize: 18,
                            fontWeight: ApzFontWeight.headingsBold,
                            color: const Color(0xFF00ADC1),
                          ),
                          const SizedBox(height: 9),
                          ApzText(
                            label: accountDashboardPromotions[selectedIndex]
                                .description,
                            fontSize: 14,
                            fontWeight: ApzFontWeight.bodyMedium,
                            color: const Color(0xFF171717),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPaymentCardContainer({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children
            .asMap()
            .entries
            .map(
              (entry) => Column(
                children: [
                  entry.value,
                  if (entry.key != children.length - 1)
                    Divider(
                      height: 16,
                      color: AppColors.dashboardSavingsDividerColor(context),
                    ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildDepositToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: ShapeDecoration(
          color: AppColors.transactionTagBackground(context),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0x597D7D84)),
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => depositType = "Fixed"),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: depositType == "Fixed"
                      ? Colors.white
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: ApzText(
                  label: 'Fixed',
                  color: depositType == "Fixed"
                      ? const Color(0xFF181818)
                      : AppColors.primary_text(context),
                  fontSize: 12,
                  fontWeight: depositType == "Fixed"
                      ? ApzFontWeight.bodyMedium
                      : ApzFontWeight.bodyRegular,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => depositType = "Recurring"),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: ShapeDecoration(
                  color: depositType == "Recurring"
                      ? Colors.white
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: ApzText(
                  label: 'Recurring',
                  color: depositType == "Recurring"
                      ? const Color(0xFF181818)
                      : AppColors.primary_text(context),
                  fontSize: 12,
                  fontWeight: depositType == "Recurring"
                      ? ApzFontWeight.bodyMedium
                      : ApzFontWeight.bodyRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
