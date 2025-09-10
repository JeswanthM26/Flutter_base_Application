import 'dart:convert';
import 'dart:ui';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:Retail_Application/ui/widgets/balance_chart.dart';
import 'package:Retail_Application/ui/widgets/upcoming_payments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as carousel_cs;
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/dashboard/customer_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPage = 0;
  int selectedIndex =
      0; // 0 = Accounts, 1 = Deposits, 2 = Loans, 3 = Credit Cards

  final carousel_cs.CarouselSliderController _carouselController =
      carousel_cs.CarouselSliderController();

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/account_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['apiResponse']['ResponseBody']['responseObj'];
  }

  Future<Map<String, dynamic>> _loadDepositsData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/deposits_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['APZRMB__DepositDetails_Res']['apiResponse']
        ['ResponseBody']['responseObj'];
  }

  Future<Map<String, dynamic>> _loadLoansData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/loans_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['APZRMB__LoanDetails_Res']['apiResponse']['ResponseBody']
        ['responseObj'];
  }

  Future<Map<String, dynamic>> _loadCreditData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/credit_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['APZRMB__CreditCardDetails_Res']['apiResponse']
        ['ResponseBody']['responseObj'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _loadDashboardData(),
        _loadDepositsData(),
        _loadLoansData(),
        _loadCreditData(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        final accountResponse = snapshot.data![0];
        final depositsResponse = snapshot.data![1];
        final loansResponse = snapshot.data![2];
        final creditResponse = snapshot.data![3];

        final customer =
            CustomerModel.fromJson(accountResponse['customerDetails']);

        final accounts = (accountResponse['accountDetails'] as List)
            .map((acc) => AccountModel.fromJson(acc))
            .toList();

        final deposits = (depositsResponse['deposits'] as List?) ?? [];
        final loans = (loansResponse['loans'] as List?) ?? [];
        final creditCards = (creditResponse['creditCards'] as List?) ?? [];

        if (accounts.isEmpty) {
          return Center(
            child: Text("No accounts found"),
          );
        }
        // Main content, no Scaffold/SafeArea
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? "assets/images/dark_theme.png"
                    : "assets/images/light_theme.png",
                fit: BoxFit.cover,
              ),
            ),
            // Content scrollable, padded, with extra bottom padding
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, kToolbarHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DashboardInfoCards(
                    items: [
                      {
                        "title": "Accounts",
                        "count": accounts.length,
                        "icon": Icons.account_balance
                      },
                      {
                        "title": "Deposits",
                        "count": deposits.length,
                        "icon": Icons.savings
                      },
                      {
                        "title": "Loans",
                        "count": loans.length,
                        "icon": Icons.money
                      },
                      {
                        "title": "Credit Cards",
                        "count": creditCards.length,
                        "icon": Icons.credit_card
                      },
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: CarouselSlider.builder(
                      carouselController: _carouselController,
                      itemCount: accounts.length,
                      options: CarouselOptions(
                        height: 180,
                        viewportFraction: 0.85,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: accounts.length > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIdx) {
                        return BalanceCard(
                          account: accounts[index],
                          currentPage: _currentPage,
                          totalAccounts: accounts.length,
                          carouselController: _carouselController,
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(Icons.repeat, "Transfer", () {
                        print("Transfer clicked");
                      }),
                      _actionButton(Icons.qr_code, "Scan to Pay", () {
                        print("Scan to Pay clicked");
                      }),
                      _actionButton(Icons.receipt_long, "Pay Bills", () {
                        print("Pay Bills clicked");
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 300,
                    child: BalanceTrendChart(),
                  ),
                  const SizedBox(height: 12),
                  const UpcomingPaymentsCard(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.50, -0.32),
                end: Alignment(0.50, 1.32),
                colors: [
                  AppColors.dashboardActionButtonBgStart(context),
                  AppColors.dashboardActionButtonBgEnd(context)
                ],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    color: AppColors.dashboardActionButtonBorderColor(context)),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: [
                BoxShadow(
                  color: AppColors.dashboardActionButtonShadow1(context),
                  blurRadius: 2,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.dashboardActionButtonShadow2(context),
                  blurRadius: 4,
                  offset: Offset(0, -4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(icon,
                  size: 28,
                  color: AppColors.dashboardActionButtonIconColor(context)),
            ),
          ),
          const SizedBox(height: 6),
          ApzText(
            label: label,
            fontSize: 12,
            fontWeight: ApzFontWeight.titlesMedium,
            color: AppColors.dashboardActionButtonLabelColor(context),
          ),
        ],
      ),
    );
  }
}

class DashboardInfoCards extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const DashboardInfoCards({super.key, required this.items});

  @override
  State<DashboardInfoCards> createState() => _DashboardInfoCardsState();
}

class _DashboardInfoCardsState extends State<DashboardInfoCards> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero, // Reduced vertical padding
      child: Row(
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SelectableInfoCard(
              key: ValueKey(item['title']),
              title: item['title'],
              count: item['count'],
              icon: item['icon'],
              selected: selectedIndex == index,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }
}

class SelectableInfoCard extends StatelessWidget {
  final String title;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const SelectableInfoCard({
    super.key,
    required this.title,
    required this.count,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = selected
        ? AppColors.dashboardInfoCardSelectedText(context)
        : AppColors.dashboardInfoCardUnselectedText(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        key: ValueKey(title),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: selected
            ? ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(1.0, 0.5),
                  end: Alignment(-0.29, 0.5),
                  colors: [
                    AppColors.dashboardInfoCardGradientStart(context),
                    AppColors.dashboardInfoCardGradientEnd(context)
                  ],
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1,
                      color: AppColors.dashboardInfoCardBorderColor(context)),
                  borderRadius: BorderRadius.circular(20),
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 4),
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ApzText(
                key: ValueKey(title),
                label: title,
                color: textColor,
                fontSize: 12,
                fontWeight: ApzFontWeight.titlesRegular,
              ),
            ),
            const SizedBox(width: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 16,
              height: 16,
              decoration: ShapeDecoration(
                color: selected
                    ? AppColors.dashboardInfoCardCountSelectedBg(context)
                    : AppColors.dashboardInfoCardCountUnselectedBg(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Center(
                  child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ApzText(
                  key: ValueKey(count),
                  label: "$count",
                  color: selected
                      ? AppColors.dashboardInfoCardCountSelectedText(context)
                      : AppColors.dashboardInfoCardCountUnselectedText(context),
                  fontSize: 11,
                  fontWeight: ApzFontWeight.titlesRegular,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceCard extends StatefulWidget {
  final AccountModel account;
  final int currentPage;
  final int totalAccounts;
  final carousel_cs.CarouselSliderController carouselController;

  const BalanceCard({
    super.key,
    required this.account,
    required this.currentPage,
    required this.totalAccounts,
    required this.carouselController,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final maskedAccNumber =
        "** ${widget.account.accountNo.substring(widget.account.accountNo.length - 4)}";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ApzText(
                label: 'AVAILABLE BALANCE',
                color: AppColors.dashboardAvailableBalanceTextColor(context),
                fontSize: 13,
                fontWeight: ApzFontWeight.titlesRegular,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: _isBalanceVisible
                        ? ApzText(
                            label:
                                "${widget.account.currency} ${widget.account.availableBalance}",
                            key: const ValueKey("visibleBalance"),
                            fontSize: 20,
                            fontWeight: ApzFontWeight.headingsBold,
                            color: AppColors.dashboardBalanceVisibleTextColor(
                                context),
                          )
                        : ImageFiltered(
                            key: const ValueKey("hiddenBalance"),
                            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: ApzText(
                              label:
                                  "${widget.account.currency} ${widget.account.availableBalance}",
                              fontSize: 20,
                              fontWeight: ApzFontWeight.headingsBold,
                              color: AppColors.dashboardBalanceHiddenTextColor(
                                  context),
                            ),
                          ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBalanceVisible = !_isBalanceVisible;
                      });
                    },
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.dashboardVisibilityIconColor(context),
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 25,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ApzText(
                      label: "My Savings",
                      color: AppColors.dashboardSavingsTextColor(context),
                      fontSize: 13,
                      fontWeight: ApzFontWeight.bodyMedium,
                    ),
                    Container(
                      width: 1.5,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: ShapeDecoration(
                        color: AppColors.dashboardSavingsDividerColor(context),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)),
                      ),
                    ),
                    ApzText(
                        label: maskedAccNumber,
                        color: AppColors.dashboardSavingsTextColor(context),
                        fontSize: 13,
                        fontWeight: ApzFontWeight.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.dashboardIndicatorBgColor(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ApzText(
                      label:
                          "${widget.currentPage + 1}/${widget.totalAccounts}",
                      fontSize: 11,
                      fontWeight: ApzFontWeight.headingsBold,
                      color: AppColors.dashboardIndicatorTextColor(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: List.generate(widget.totalAccounts, (dotIndex) {
                      return GestureDetector(
                        onTap: () {
                          widget.carouselController.animateToPage(dotIndex);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.currentPage == dotIndex
                                ? AppColors.dashboardIndicatorDotActive(context)
                                : AppColors.dashboardIndicatorDotInactive(
                                    context),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
