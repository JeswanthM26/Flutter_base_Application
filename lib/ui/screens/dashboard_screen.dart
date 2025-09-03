import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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

  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.85, // makes it a carousel
  );

  Future<Map<String, dynamic>> _loadDashboardData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/account_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['apiResponse']['ResponseBody']['responseObj'];
  }

  // Deposits
  Future<Map<String, dynamic>> _loadDepositsData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/deposits_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['APZRMB__DepositDetails_Res']['apiResponse']
            ['ResponseBody']
        ['responseObj']; // or adjust depending on JSON structure
  }

// Loans
  Future<Map<String, dynamic>> _loadLoansData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/loans_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['APZRMB__LoanDetails_Res']['apiResponse']['ResponseBody']
        ['responseObj'];
  }

// Credit Cards
  Future<Map<String, dynamic>> _loadCreditData() async {
    final String data =
        await rootBundle.loadString('mock/Dashboard/credit_mock.json');
    final jsonResult = json.decode(data);
    return jsonResult['APZRMB__CreditCardDetails_Res']['apiResponse']
        ['ResponseBody']['responseObj'];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _loadDashboardData(), // accounts
        _loadDepositsData(), // deposits
        _loadLoansData(), // loans
        _loadCreditData(), // credit cards
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        // Extract data
        final accountResponse = snapshot.data![0];
        final depositsResponse = snapshot.data![1];
        final loansResponse = snapshot.data![2];
        final creditResponse = snapshot.data![3];

        // Customer data from accounts JSON
        final customer =
            CustomerModel.fromJson(accountResponse['customerDetails']);

        // Accounts list
        final accounts = (accountResponse['accountDetails'] as List)
            .map((acc) => AccountModel.fromJson(acc))
            .toList();

// Deposits, Loans, Credit Cards
        final deposits = (depositsResponse['deposits'] as List?) ?? [];
        final loans = (loansResponse['loans'] as List?) ?? [];
        final creditCards = (creditResponse['creditCards'] as List?) ?? [];

        if (accounts.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No accounts found")),
          );
        }
        return Scaffold(
          body: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  "assets/mock/Bg.png",
                  fit: BoxFit.cover,
                ),
              ),
              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
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
                      // 🔹 Balance Card with PageView
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: accounts.length,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            double scale = _currentPage == index
                                ? 1.0
                                : 0.9; // scale inactive cards
                            return Transform.scale(
                              scale: scale,
                              child: BalanceCard(
                                account: accounts[index],
                                currentPage: _currentPage,
                                pageController: _pageController,
                                totalAccounts: accounts.length,
                              ),
                            );
                          },
                        ),
                      ),

                      // const SizedBox(height: 24),
                      // 🔹 Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionButton(Icons.sync_alt, "Transfer", () {
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
                      Expanded(
                        child: Center(
                          child: Text(
                            "📈 Money Movement Chart (Coming Soon)",
                            style: TextStyle(color: Colors.grey.shade600),
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
              gradient: const LinearGradient(
                begin: Alignment(0.50, -0.32),
                end: Alignment(0.50, 1.32),
                colors: [Colors.white, Color(0xFFEFF4FF)],
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 2,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 4,
                  offset: Offset(0, -4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, size: 28, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class DashboardInfoCards extends StatefulWidget {
  final List<Map<String, dynamic>> items; // title, count, icon
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SelectableInfoCard(
              key: ValueKey(item['title']), // ensures widget is persistent
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
    final textColor = selected ? const Color(0xFF181818) : Colors.grey.shade600;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        key: ValueKey(title), // keeps the widget persistent
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: selected
            ? ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(1.0, 0.5),
                  end: Alignment(-0.29, 0.5),
                  colors: [Color(0xFFB3E0FF), Color(0x33B3E0FF)],
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Colors.white),
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
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
              child: Text(title),
            ),
            const SizedBox(width: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 16,
              height: 16,
              decoration: ShapeDecoration(
                color:
                    selected ? const Color(0xFF4FA8DE) : Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade600,
                    fontSize: 11,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                  child: Text("$count", textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 BalanceCard separated to avoid flickering
class BalanceCard extends StatefulWidget {
  final AccountModel account;
  final int currentPage;
  final PageController pageController;
  final int totalAccounts;

  const BalanceCard({
    super.key,
    required this.account,
    required this.currentPage,
    required this.pageController,
    required this.totalAccounts,
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
              Text(
                'AVAILABLE BALANCE',
                style: const TextStyle(
                  color: Color(0xFF57768B),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
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
                        ? Text(
                            "${widget.account.currency} ${widget.account.availableBalance}",
                            key: const ValueKey("visibleBalance"),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF181818),
                            ),
                          )
                        : ImageFiltered(
                            key: const ValueKey("hiddenBalance"),
                            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Text(
                              "${widget.account.currency} ${widget.account.availableBalance}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF181818),
                              ),
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
                      color: Colors.black,
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
                    Text(
                      "My Savings",
                      style: const TextStyle(
                        color: Color(0xFF4EA8DE),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Container(
                      width: 1.5,
                      height: 16,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: ShapeDecoration(
                        color: const Color(0x5181B4D6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1)),
                      ),
                    ),
                    Text(
                      maskedAccNumber,
                      style: const TextStyle(
                        color: Color(0xFF4EA8DE),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 🔹 Indicator Row moved inside BalanceCard
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${widget.currentPage + 1}/${widget.totalAccounts}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SmoothPageIndicator(
                    controller: widget.pageController,
                    count: widget.totalAccounts,
                    effect: WormEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      activeDotColor: Colors.blue,
                      dotColor: Colors.grey.shade400,
                    ),
                    onDotClicked: (index) {
                      widget.pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
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
}
