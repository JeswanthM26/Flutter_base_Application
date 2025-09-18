import 'dart:convert';
import 'dart:ui';
import 'package:Retail_Application/models/dashboard/actionbuttons_model.dart';
import 'package:Retail_Application/models/dashboard/creditcard_model.dart';
import 'package:Retail_Application/models/financials/deposit_model.dart';
import 'package:Retail_Application/models/financials/loan_model.dart';
import 'package:Retail_Application/ui/widgets/apz_creditcard_chart.dart';
import 'package:Retail_Application/ui/widgets/apz_deposit_chart.dart';
import 'package:Retail_Application/ui/widgets/apz_loan_chart.dart';
import 'package:Retail_Application/ui/widgets/favourite_transactions.dart';
import 'package:Retail_Application/ui/widgets/promotions.dart';
import 'package:Retail_Application/ui/widgets/recent_transactions.dart';
import 'package:Retail_Application/ui/widgets/show_transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as carousel_cs;

import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:Retail_Application/ui/widgets/balance_chart.dart';
import 'package:Retail_Application/ui/widgets/upcoming_payments.dart';
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/dashboard/customer_model.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<AccountScreen> {
  int _currentPage = 0;
  int selectedIndex = 0;
  final Map<String, GlobalKey<State<StatefulWidget>>> _actionButtonKeys = {};
  String? _highlightedButtonScreenID;

  // keep per-tab last pages
  Map<int, int> _carouselPages = {
    0: 0, // Accounts
    1: 0, // Deposits
    2: 0, // Loans
    3: 0, // Credit Cards
  };
  Widget _buildChart(int selectedIndex, dynamic currentItem) {
    switch (selectedIndex) {
      case 0:
        return BalanceTrendChart(
            accountData: currentItem); // line chart for Accounts
      case 1:
        return DepositsChartExample(
          depositData: currentItem,
        );
      case 2:
        return LoansChartExample(
          loan: currentItem,
        );
      case 3:
        return CreditCardChartExample(
          creditData: currentItem,
        ); // donut charts for others
      default:
        return BalanceTrendChart(accountData: currentItem);
    }
  }

  final carousel_cs.CarouselSliderController _carouselController =
      carousel_cs.CarouselSliderController();

  // include action buttons future
  late final Future<List<dynamic>> _allDataFuture = Future.wait([
    _loadDashboardData(), // Accounts
    _loadDepositData(),
    _loadLoanData(),
    _loadCreditData(), // Credit cards
    _loadActionButtons(), // action buttons
  ]);

  // ---------------- data loaders ----------------
  Future<Map<String, dynamic>> _loadDashboardData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/account_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['apiResponse']['ResponseBody']['responseObj'];
  }

  Future<Map<String, dynamic>> _loadCreditData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/credit_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['APZRMB__CreditCardDetails_Res']['apiResponse']
        ['ResponseBody']['responseObj'];
  }

  Future<Map<String, dynamic>> _loadDepositData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/deposits_mock.json');
    final jsonResult = json.decode(data);

    return jsonResult['APZRMB__DepositDetails_Res']?['apiResponse']
            ?['ResponseBody']?['responseObj'] ??
        {}; // return empty map if null
  }

  Future<Map<String, dynamic>> _loadLoanData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/loans_mock.json');
    final jsonResult = json.decode(data);

    return jsonResult['APZRMB__LoanDetails_Res']?['apiResponse']
            ?['ResponseBody']?['responseObj'] ??
        {}; // return empty map if null
  }

  Future<List<ActionButtonModel>> _loadActionButtons() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/actionbuttons_mock.json');
    final jsonResult = json.decode(data);
    final List list = jsonResult['APZRMB__ActionButtons_Res']['apiResponse']
        ['ResponseBody']['responseObj']['actionButtons'];
    return list.map((e) => ActionButtonModel.fromJson(e)).toList();
  }

  // ---------------- helper to map icon-string -> IconData ----------------
  IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'transfer-new':
        return Icons.repeat;
      case 'scan-pay-new':
        return Icons.qr_code;
      case 'pay-bill-new':
        return Icons.receipt_long;
      case 'icon-applyDeposit':
        return Icons.add_circle_outline;
      case 'view-details':
        return Icons.remove_red_eye;
      case 'icon-raiseComplaint':
        return Icons.report_problem;
      case 'icon-card':
        return Icons.credit_card;
      case 'icon-manageLimits':
        return Icons.tune;
      default:
        return Icons.apps; // fallback
    }
  }

  // map selectedIndex to the "action" string used in the JSON
  String _actionNameForIndex(int idx) {
    switch (idx) {
      case 0:
        return 'Account';
      case 1:
        return 'Deposit';
      case 2:
        return 'Loan';
      case 3:
        return 'Credit Card';
      default:
        return 'Account';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _allDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // unpack futures
        final accountResponse = snapshot.data![0] as Map<String, dynamic>;
        final depositResponse = snapshot.data![1] as Map<String, dynamic>;
        final loanResponse = snapshot.data![2] as Map<String, dynamic>;
        final creditResponse = snapshot.data![3] as Map<String, dynamic>;
        final actionButtons = snapshot.data![4] as List<ActionButtonModel>;

        final customer =
            CustomerModel.fromJson(accountResponse['customerDetails']);

        final allAccounts = (accountResponse['accountDetails'] as List)
            .map((acc) => AccountModel.fromJson(acc))
            .toList();

        // split by accountType
        final accounts = allAccounts
            .where((acc) => acc.accountType == "SB" || acc.accountType == "CA")
            .toList();

        final deposits = (depositResponse['accounts'] as List? ?? [])
            .map((dep) => DepositAccount.fromJson(dep))
            .toList();

        final loans = (loanResponse['loans'] as List? ?? [])
            .map((loan) => Loan.fromJson(loan))
            .toList();

        final creditCards = (creditResponse['creditCards'] as List?)
                ?.map((cc) => CreditCardModel.fromJson(cc))
                .toList() ??
            [];

        // Pick current dataset for carousel
        List<dynamic> currentData;
        switch (selectedIndex) {
          case 1:
            currentData = deposits;
            break;
          case 2:
            currentData = loans;
            break;
          case 3:
            currentData = creditCards;
            break;
          default:
            currentData = accounts;
        }

        return _buildMainUI(
          context,
          accounts,
          deposits,
          loans,
          creditCards,
          currentData,
          actionButtons,
        );
      },
    );
  }

  // NOTE: added currentActions param
  Widget _buildMainUI(
    BuildContext context,
    List accounts,
    List deposits,
    List loans,
    List creditCards,
    List currentData,
    List<ActionButtonModel> currentActions,
  ) {
    // helper to pick dataset by index (used when switching tabs)
    List<dynamic> _datasetForIndex(int index) {
      switch (index) {
        case 1:
          return deposits;
        case 2:
          return loans;
        case 3:
          return creditCards;
        default:
          return accounts;
      }
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, kToolbarHeight),
          child: Column(
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
                    "icon": Icons.save_outlined
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
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  // restore last page for the new tab and ensure it is within bounds
                  final dataset = _datasetForIndex(index);
                  final saved = _carouselPages[index] ?? 0;
                  final target = (dataset.isNotEmpty)
                      ? (saved.clamp(0, dataset.length - 1))
                      : 0;

                  setState(() {
                    selectedIndex = index;
                    _currentPage = target;
                  });

                  // after the frame, instruct controller to move to saved page (if carousel exists)
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_carouselController != null) {
                      _carouselController.animateToPage(_currentPage);
                    }
                  });
                },
              ),
              const SizedBox(height: 20),
              if (currentData.isNotEmpty)
                CarouselSlider.builder(
                  key: ValueKey(selectedIndex),
                  carouselController: _carouselController,
                  itemCount: currentData.length,
                  options: CarouselOptions(
                    height: 100,
                    viewportFraction: 0.85,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: _currentPage,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                        _carouselPages[selectedIndex] = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return BalanceCard(
                      data: currentData[index],
                      // currentPage: _currentPage,
                      // totalItems: currentData.length,
                      carouselController: _carouselController,
                    );
                  },
                ),

              // const SizedBox(height: 8),
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
                      label: "${_currentPage + 1}/${currentData.length}",
                      fontSize: 11,
                      fontWeight: ApzFontWeight.headingsBold,
                      color: AppColors.dashboardIndicatorTextColor(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: List.generate(currentData.length, (dotIndex) {
                      return GestureDetector(
                        onTap: () {
                          _carouselController.animateToPage(dotIndex);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == dotIndex
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
              const SizedBox(height: 24),
              // dynamic action buttons row (filtered by tab)
              _buildActionButtonsRow(currentActions, selectedIndex),
              const SizedBox(height: 12),
              SizedBox(
                height: 300,
                child: _buildChart(
                  selectedIndex,
                  currentData.isNotEmpty ? currentData[_currentPage] : null,
                ),
              ),

              const SizedBox(height: 12),
              const UpcomingPaymentsCardWidget(),
              const FavoriteTransactionsRow(),
              const RecentTransactions(),
              const Promotions()
            ],
          ),
        ),
      ],
    );
  }

  // Build action button row that filters actionButtons by the selected tab
  Widget _buildActionButtonsRow(
      List<ActionButtonModel> allActions, int selectedIndex) {
    final actionName = _actionNameForIndex(selectedIndex);
    final filtered = allActions.where((a) => a.action == actionName).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: filtered.map((act) {
        // Fix: properly get or create key
        final key = _actionButtonKeys[act.value ?? ''] ??
            GlobalKey<State<StatefulWidget>>();
        _actionButtonKeys[act.value ?? ''] = key;

        final icon = _mapIcon(act.icon ?? '');

        return _actionButton(
          key: key,
          icon: icon,
          label: act.value ?? '',
          screenID: act.screenID,
          onTap: () {
            debugPrint(
                'Action tapped: screen=${act.screenID} value=${act.value}');
          },
          onLongPress: act.screenID == "TransactionApp"
              ? () {
                  HapticFeedback.mediumImpact();
                  showTransferModelAtButton(
                    context,
                    key,
                    (isHighlighted) {
                      setState(() {
                        _highlightedButtonScreenID =
                            isHighlighted ? act.screenID : null;
                      });
                    },
                  );
                }
              : null,
        );
      }).toList(),
    );
  }

  Widget _actionButton({
    required Key key,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    String? screenID,
  }) {
    final isHighlighted = _highlightedButtonScreenID == screenID;

    return AnimatedScale(
      scale: isHighlighted ? 1.05 : 1.0, // Lift animation
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: GestureDetector(
        key: key,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.50, -0.32),
                  end: const Alignment(0.50, 1.32),
                  colors: [
                    AppColors.dashboardActionButtonBgStart(context),
                    AppColors.dashboardActionButtonBgEnd(context),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: AppColors.dashboardActionButtonBorderColor(context),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: AppColors.dashboardActionButtonShadow1(context),
                    blurRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.dashboardActionButtonShadow2(context),
                    blurRadius: 4,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 28,
                  color: AppColors.dashboardActionButtonIconColor(context),
                ),
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
      ),
    );
  }
}

class DashboardInfoCards extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const DashboardInfoCards({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<DashboardInfoCards> createState() => _DashboardInfoCardsState();
}

class _DashboardInfoCardsState extends State<DashboardInfoCards> {
  late int localSelectedIndex;

  @override
  void initState() {
    super.initState();
    localSelectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant DashboardInfoCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      localSelectedIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
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
              selected: localSelectedIndex == index,
              onTap: () {
                HapticFeedback.heavyImpact();
                setState(() {
                  localSelectedIndex = index;
                });
                widget.onItemSelected(index);
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
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 4),
            ],
            ApzText(
              label: title,
              color: textColor,
              fontSize: 12,
              fontWeight: ApzFontWeight.titlesRegular,
            ),
            const SizedBox(width: 4),
            Container(
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
                child: ApzText(
                  label: "$count",
                  color: selected
                      ? AppColors.dashboardInfoCardCountSelectedText(context)
                      : AppColors.dashboardInfoCardCountUnselectedText(context),
                  fontSize: 11,
                  fontWeight: ApzFontWeight.titlesRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceCard extends StatefulWidget {
  final dynamic data; // AccountModel or CreditCardModel
  final carousel_cs.CarouselSliderController carouselController;

  const BalanceCard({
    super.key,
    required this.data,
    required this.carouselController,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = false;
  static final Map<String, bool> _visibilityMap = {};

  @override
  Widget build(BuildContext context) {
    String uniqueKey;
    if (widget.data is AccountModel) {
      uniqueKey = (widget.data as AccountModel).accountNo;
    } else if (widget.data is CreditCardModel) {
      uniqueKey = (widget.data as CreditCardModel).cardNumber;
    } else if (widget.data is DepositAccount) {
      uniqueKey = (widget.data as DepositAccount).accountNo;
    } else if (widget.data is Loan) {
      uniqueKey = (widget.data as Loan).accountNo;
    } else {
      uniqueKey = "unknown";
    }
    String balanceLabel = "";

    if (widget.data is AccountModel) {
      balanceLabel = "AVAILABLE BALANCE";
    } else if (widget.data is DepositAccount) {
      balanceLabel = "DEPOSIT AMOUNT";
    } else if (widget.data is Loan) {
      balanceLabel = "OUTSTANDING BALANCE";
    } else if (widget.data is CreditCardModel) {
      balanceLabel = "TOTAL OUTSTANDING";
    }

    _isBalanceVisible = _visibilityMap[uniqueKey] ?? false;

    String title = "";
    String subtitle = "";
    String balance = "";
    String currency = "";

    final formatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 2);

    if (widget.data is AccountModel) {
      final acc = widget.data as AccountModel;
      title = acc.accountType == "CA"
          ? "Current Account"
          : acc.accountType == "SB"
              ? "Savings Account"
              : "Account";
      subtitle = "** ${acc.accountNo.substring(acc.accountNo.length - 4)}";
      balance = formatter.format(double.parse(acc.availableBalance));
      currency = acc.currency;
    } else if (widget.data is CreditCardModel) {
      final cc = widget.data as CreditCardModel;
      title = "Credit Card";
      subtitle = "** ${cc.cardNumber.substring(cc.cardNumber.length - 4)}";
      balance = formatter.format(cc.availableCredit);
      currency = cc.currency;
    } else if (widget.data is DepositAccount) {
      final dep = widget.data as DepositAccount;
      title = dep.accountType == "FD"
          ? "Fixed Deposit"
          : dep.accountType == "RD"
              ? "Recurring Deposit"
              : "Deposit";
      subtitle = "** ${dep.accountNo.substring(dep.accountNo.length - 4)}";
      balance = formatter.format(
        (double.tryParse(dep.depositAmount ?? "0") ?? 0) +
            (double.tryParse(dep.interestAmount ?? "0") ?? 0),
      );
      currency = dep.currency;
    } else if (widget.data is Loan) {
      final loan = widget.data as Loan;
      title = loan.loanType == "RL"
          ? "Retail Loan"
          : loan.loanType == "CL"
              ? "Consumer Loan"
              : loan.loanType == "VL"
                  ? "Vehicle Loan"
                  : loan.loanType == "HL"
                      ? "Home Loan"
                      : loan.loanType == "PL"
                          ? "Personal Loan"
                          : loan.loanType == "EL"
                              ? "Education Loan"
                              : "Loan";
      subtitle = "** ${loan.accountNo.substring(loan.accountNo.length - 4)}";
      double _safeParse(String? value) {
        if (value == null || value.isEmpty) return 0.0;
        return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
      }

      balance = formatter.format(_safeParse(loan.availableBalance));

      currency = loan.currency;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ApzText(
                label: balanceLabel,
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
                            label: "$currency $balance",
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
                              label: "$currency $balance",
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
                        _visibilityMap[uniqueKey] = _isBalanceVisible;
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
                      label: title,
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
                        label: subtitle,
                        color: AppColors.dashboardSavingsTextColor(context),
                        fontSize: 13,
                        fontWeight: ApzFontWeight.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
