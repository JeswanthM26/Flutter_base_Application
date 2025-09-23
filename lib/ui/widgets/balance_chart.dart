import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retail_application/models/dashboard/account_model.dart';
import 'package:retail_application/models/dashboard/balancetrend_model.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:fl_chart/fl_chart.dart';

class BalanceTrendChart extends StatefulWidget {
  final AccountModel? accountData;

  const BalanceTrendChart({super.key, this.accountData});

  @override
  State<BalanceTrendChart> createState() => _BalanceTrendChartState();
}

class _BalanceTrendChartState extends State<BalanceTrendChart> {
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> _data = [];

  FlSpot? touchedSpot;
  List<int> xAxisIndices = [];
  Map<int, String> xAxisLabels = {};
  List<double> yAxisLabels = [];

  int displayPage = 0;
  int maxPageIndex = 0;
  List<DateTime> uniqueMonthStarts = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  @override
  void didUpdateWidget(covariant BalanceTrendChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountData?.accountNo != widget.accountData?.accountNo) {
      _loadMockData();
    }
  }

  Future<void> _loadMockData() async {
    final String response =
        await rootBundle.loadString('mock/Dashboard/balance_mock.json');
    final jsonResult = json.decode(response);

    final balanceTrendList = jsonResult["apiResponse"]["ResponseBody"]
        ["responseObj"]["balanceTrendDetails"] as List;

    final allAccounts =
        balanceTrendList.map((e) => BalanceTrendModel.fromJson(e)).toList();

    final selectedAccount = widget.accountData != null
        ? allAccounts.firstWhere(
            (acc) => acc.accountNo == widget.accountData!.accountNo,
            orElse: () => BalanceTrendModel(accountNo: '', trend: []),
          )
        : allAccounts.isNotEmpty
            ? allAccounts.first
            : BalanceTrendModel(accountNo: '', trend: []);

    allData = selectedAccount.trend.map((e) {
      return {
        "date": e["date"],
        "balance":
            double.tryParse(e["balance"].toString().replaceAll(",", "")) ?? 0,
      };
    }).toList();

    final dates = allData.map((e) => DateTime.parse(e["date"])).toList();
    dates.sort();
    DateTime now = DateTime.now();
    DateTime currentMonthStart = DateTime(now.year, now.month);
    DateTime? lastStart;
    uniqueMonthStarts = [];

    for (final d in dates) {
      final monthStart = DateTime(d.year, d.month);
      if ((lastStart == null ||
              monthStart.year != lastStart.year ||
              monthStart.month != lastStart.month) &&
          monthStart.isBefore(currentMonthStart)) {
        uniqueMonthStarts.add(monthStart);
        lastStart = monthStart;
      }
    }

    maxPageIndex = uniqueMonthStarts.length;
    _updateView();
  }

  void _updateView() {
    if (allData.isEmpty) return;

    List<Map<String, dynamic>> newData;
    List<int> indicesForXAxis = [];
    Map<int, String> labels = {};

    if (displayPage == 0) {
      DateTime latest = allData
          .map((e) => DateTime.parse(e["date"]))
          .reduce((a, b) => a.isAfter(b) ? a : b);
      DateTime lower = latest.subtract(const Duration(days: 28));

      newData = allData.where((e) {
        DateTime d = DateTime.parse(e["date"]);
        return !d.isBefore(lower) && !d.isAfter(latest);
      }).toList();

      if (newData.isEmpty && allData.isNotEmpty) {
        newData = [allData.last];
      }

      List<DateTime> tickDates =
          List.generate(5, (i) => latest.subtract(Duration(days: i * 7)))
              .reversed
              .toList();

      for (var targetDate in tickDates) {
        int closestIndex = 0;
        int minDiff = 1000000;
        for (int i = 0; i < newData.length; i++) {
          DateTime d = DateTime.parse(newData[i]["date"]);
          int diff = (d.difference(targetDate).inDays).abs();
          if (diff < minDiff) {
            minDiff = diff;
            closestIndex = i;
          }
        }
        indicesForXAxis.add(closestIndex);
      }

      indicesForXAxis = indicesForXAxis.toSet().toList()..sort();

      for (var index in indicesForXAxis) {
        final date = DateTime.parse(newData[index]["date"]);
        if (_isSameDate(date, DateTime.now())) {
          labels[index] = "Today";
        } else {
          final formattedDay = date.day.toString().padLeft(2, '0');
          labels[index] = "$formattedDay'${_monthName(date.month)}";
        }
      }
    } else {
      int idx = uniqueMonthStarts.length - displayPage;
      if (idx < 0) idx = 0;

      DateTime monthStart = uniqueMonthStarts[idx];
      DateTime nextMonthStart = idx + 1 < uniqueMonthStarts.length
          ? uniqueMonthStarts[idx + 1]
          : DateTime(monthStart.year, monthStart.month + 1);

      newData = allData.where((e) {
        DateTime d = DateTime.parse(e["date"]);
        return !d.isBefore(monthStart) && d.isBefore(nextMonthStart);
      }).toList();

      if (newData.isEmpty && allData.isNotEmpty) {
        newData = [allData.last];
      }

      DateTime latestDate = newData
          .map((e) => DateTime.parse(e["date"]))
          .reduce((a, b) => a.isAfter(b) ? a : b);

      List<DateTime> tickDates =
          List.generate(5, (i) => latestDate.subtract(Duration(days: i * 7)))
              .reversed
              .toList();

      for (var targetDate in tickDates) {
        int closestIndex = 0;
        int minDiff = 1000000;
        for (int i = 0; i < newData.length; i++) {
          DateTime d = DateTime.parse(newData[i]["date"]);
          int diff = (d.difference(targetDate).inDays).abs();
          if (diff < minDiff) {
            minDiff = diff;
            closestIndex = i;
          }
        }
        indicesForXAxis.add(closestIndex);
      }

      indicesForXAxis = indicesForXAxis.toSet().toList()..sort();

      for (var index in indicesForXAxis) {
        final date = DateTime.parse(newData[index]["date"]);
        final formattedDay = date.day.toString().padLeft(2, '0');
        labels[index] = "$formattedDay'${_monthName(date.month)}";
      }
    }

    if (newData.isEmpty) {
      setState(() {
        _data = [];
        xAxisIndices = [];
        xAxisLabels = {};
        yAxisLabels = [];
      });
      return;
    }

    double maxBalance = newData
        .map((e) => e["balance"] as double)
        .reduce((a, b) => a > b ? a : b);
    double maxY = (maxBalance / 1000).ceil() * 1000;
    double yStep = maxY / 3;
    List<double> yLabels = [yStep, 2 * yStep, maxY];

    setState(() {
      _data = newData;
      xAxisIndices = indicesForXAxis;
      xAxisLabels = labels;
      yAxisLabels = yLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        if (_data.isEmpty)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            width: screenWidth,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: LineChart(
                _buildChartData(context),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    int currentIndex = uniqueMonthStarts.length - displayPage;
    String label = displayPage == 0
        ? "Last 4 weeks"
        : "${_monthName(uniqueMonthStarts[currentIndex].month)} ${uniqueMonthStarts[currentIndex].year}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ApzText(
              label: "Money Movement",
              fontWeight: ApzFontWeight.titlesMedium,
              fontSize: 13,
              color: AppColors.dashboardBalanceTrendTitleTextColor(context),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.dashboardBalanceTrendFilterBgColor(context),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color:
                        AppColors.dashboardBalanceTrendFilterTextColor(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: displayPage < maxPageIndex
                      ? () {
                          setState(() {
                            displayPage++;
                          });
                          _updateView();
                        }
                      : null,
                  child: Icon(
                    Icons.chevron_left,
                    size: 18,
                    color:
                        AppColors.dashboardBalanceTrendFilterIconColor(context),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: displayPage > 0
                      ? () {
                          setState(() {
                            displayPage--;
                          });
                          _updateView();
                        }
                      : null,
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color:
                        AppColors.dashboardBalanceTrendFilterIconColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(BuildContext context) {
    return LineChartData(
      minX: -0.5,
      maxX: _data.length - 0.5,
      minY: 0,
      maxY: yAxisLabels.isNotEmpty ? yAxisLabels.last : 0,
      clipData: FlClipData(
        top: false,
        bottom: false,
        left: false,
        right: false,
      ),
// ✅ Prevents clipping of vertical lines
      lineTouchData: _buildTouchData(context),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        verticalInterval: 1,
        getDrawingVerticalLine: (value) {
          if (xAxisLabels.containsKey(value.toInt())) {
            return FlLine(
              color: AppColors.upcomingPaymentsDivider(context),
              strokeWidth: 0.1,
            );
          }
          return FlLine(color: Colors.transparent);
        },
      ),
      titlesData: _buildTitlesData(context),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: _data.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value["balance"]);
          }).toList(),
          isCurved: true,
          curveSmoothness: 0.42,
          gradient: LinearGradient(
            colors: [
              AppColors.dashboardBalanceTrendLineGradientStart(context),
              AppColors.dashboardBalanceTrendLineGradientEnd(context),
            ],
          ),
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.dashboardBalanceTrendBelowLineGradientStart(context)
                    .withOpacity(0.14),
                AppColors.dashboardBalanceTrendBelowLineGradientEnd(context),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, _) =>
                touchedSpot != null &&
                spot.x == touchedSpot!.x &&
                spot.y == touchedSpot!.y,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6.5,
                color: AppColors.dashboardBalanceTrendDotFillColor(context),
                strokeWidth: 3,
                strokeColor:
                    AppColors.dashboardBalanceTrendDotBorderColor(context),
              );
            },
          ),
        ),
      ],
    );
  }

  LineTouchData _buildTouchData(BuildContext context) {
    return LineTouchData(
      enabled: true,
      touchCallback: (event, response) {
        if (response != null &&
            response.lineBarSpots != null &&
            response.lineBarSpots!.isNotEmpty) {
          setState(() {
            touchedSpot = FlSpot(
              response.lineBarSpots!.first.x,
              response.lineBarSpots!.first.y,
            );
          });
        }
      },
      touchTooltipData: LineTouchTooltipData(
        tooltipRoundedRadius: 7,
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        tooltipMargin: 10,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final spotIndex = spot.x.toInt();
            final dateString = _data[spotIndex]["date"];
            final date = DateTime.parse(dateString);
            final formattedDate =
                "${_monthName(date.month)} ${date.day.toString().padLeft(2, '0')}";
            final amount = "${(spot.y ~/ 1000)}k";
            return LineTooltipItem(
              "$formattedDate, $amount",
              TextStyle(
                color: AppColors.dashboardBalanceTrendTooltipTextColor(context),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, indicators) {
        return indicators.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: AppColors.dashboardBalanceTrendTooltipLineColor(context),
              strokeWidth: 2,
              dashArray: [6, 6],
            ),
            FlDotData(show: true),
          );
        }).toList();
      },
    );
  }

  FlTitlesData _buildTitlesData(BuildContext context) {
    return FlTitlesData(
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          interval: yAxisLabels.isNotEmpty ? yAxisLabels.first : 1000,
          getTitlesWidget: (value, meta) {
            bool show = yAxisLabels.any(
                (element) => (element - value).abs() < yAxisLabels.first * 0.1);
            return show
                ? Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      "${(value ~/ 1000)}k",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:
                            AppColors.dashboardBalanceTrendYAxisLabelTextColor(
                                context),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 48,
          getTitlesWidget: (value, meta) {
            int index = value.round();
            if (!xAxisLabels.containsKey(index)) return const SizedBox.shrink();

            String label = xAxisLabels[index]!;

            // Manually detect edges
            bool isFirst = index == 0;
            bool isLast = index == _data.length - 1;

            double leftPadding = label == "Today" ? 12.0 : 0.0;
            double rightPadding = 0.0;

            if (isLast)
              rightPadding = 6.0; // optional: add some spacing for last label

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 6,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 4, left: leftPadding, right: rightPadding),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.dashboardBalanceTrendXAxisLabelTextColor(
                        context),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
