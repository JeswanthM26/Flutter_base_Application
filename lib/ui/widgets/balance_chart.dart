import 'dart:convert';
import 'dart:math' as developer;
import 'package:Retail_Application/models/dashboard/account_model.dart';
import 'package:Retail_Application/models/dashboard/balancetrend_model.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int displayPage = 0; // 0: last 4 weeks, 1: previous month, etc.
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

    // Reload data if the account changed
    if (oldWidget.accountData?.accountNo != widget.accountData?.accountNo) {
      _loadMockData();
    }
  }

  Future<void> _loadMockData() async {
    // Load JSON
    final String response =
        await rootBundle.loadString('mock/Dashboard/balance_mock.json');
    final jsonResult = json.decode(response);

    // Extract list of balance trend details
    final balanceTrendList = jsonResult["apiResponse"]["ResponseBody"]
        ["responseObj"]["balanceTrendDetails"] as List;

    // Convert to List<BalanceTrendModel>
    final allAccounts =
        balanceTrendList.map((e) => BalanceTrendModel.fromJson(e)).toList();

    // Select account
    final selectedAccount = widget.accountData != null
        ? allAccounts.firstWhere(
            (acc) => acc.accountNo == widget.accountData!.accountNo,
            orElse: () => BalanceTrendModel(accountNo: '', trend: []),
          )
        : allAccounts.isNotEmpty
            ? allAccounts.first
            : BalanceTrendModel(accountNo: '', trend: []);

    // Convert trend to your internal format
    allData = selectedAccount.trend.map((e) {
      return {
        "date": e["date"],
        "balance":
            double.tryParse(e["balance"].toString().replaceAll(",", "")) ?? 0,
      };
    }).toList();

    // Prepare unique months for pagination (keep your existing logic)
    final dates = allData.map((e) => DateTime.parse(e["date"])).toList();
    dates.sort();
    DateTime? lastStart;
    DateTime now = DateTime.now();
    DateTime currentMonthStart = DateTime(now.year, now.month);
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
        if (date == latest) {
          labels[index] = "Today";
        } else {
          final formattedDay = date.day.toString().padLeft(2, '0');
          labels[index] = "$formattedDay'${_monthName(date.month)}";
        }
      }
    } else {
      int idx = uniqueMonthStarts.length - displayPage;
      if (idx < 0) idx = 0;
      if (uniqueMonthStarts.isEmpty) {
        newData = [];
      } else {
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
        Padding(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          AppColors.dashboardBalanceTrendFilterBgColor(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayPage == 0
                              ? "Last 4 weeks"
                              : _monthName(
                                    uniqueMonthStarts[uniqueMonthStarts.length -
                                            displayPage]
                                        .month,
                                  ) +
                                  " " +
                                  uniqueMonthStarts[uniqueMonthStarts.length -
                                          displayPage]
                                      .year
                                      .toString(),
                          style: TextStyle(
                            color:
                                AppColors.dashboardBalanceTrendFilterTextColor(
                                    context),
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
                                AppColors.dashboardBalanceTrendFilterIconColor(
                                    context),
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
                                AppColors.dashboardBalanceTrendFilterIconColor(
                                    context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                LineChartData(
                  minY: 0,
                  maxY: yAxisLabels.isNotEmpty ? yAxisLabels.last : 0,
                  lineTouchData: LineTouchData(
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
                      tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                              color: AppColors
                                  .dashboardBalanceTrendTooltipTextColor(
                                      context),
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
                            color:
                                AppColors.dashboardBalanceTrendTooltipLineColor(
                                    context),
                            strokeWidth: 2,
                            dashArray: [6, 6],
                          ),
                          FlDotData(show: true),
                        );
                      }).toList();
                    },
                  ),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval:
                            yAxisLabels.isNotEmpty ? yAxisLabels.first : 1000,
                        getTitlesWidget: (value, meta) {
                          bool show = yAxisLabels.any((element) =>
                              (element - value).abs() <
                              yAxisLabels.first * 0.1);
                          return show
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    "${(value ~/ 1000)}k",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors
                                          .dashboardBalanceTrendYAxisLabelTextColor(
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
                          int index = value.toInt();
                          if (xAxisLabels.containsKey(index)) {
                            String label = xAxisLabels[index]!;

                            // Add left padding specifically for "Today" label
                            double leftPadding = label == "Today" ? 12.0 : 0.0;

                            return Padding(
                              padding:
                                  EdgeInsets.only(top: 4, left: leftPadding),
                              child: Text(
                                label,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors
                                        .dashboardBalanceTrendXAxisLabelTextColor(
                                            context)),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
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
                          AppColors.dashboardBalanceTrendLineGradientStart(
                              context),
                          AppColors.dashboardBalanceTrendLineGradientEnd(
                              context)
                        ],
                      ),
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors
                                    .dashboardBalanceTrendBelowLineGradientStart(
                                        context)
                                .withOpacity(0.14),
                            AppColors.dashboardBalanceTrendBelowLineGradientEnd(
                                context),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(
                        show: true,
                        checkToShowDot: (spot, barData) =>
                            touchedSpot != null &&
                            spot.x == touchedSpot!.x &&
                            spot.y == touchedSpot!.y,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6.5,
                            color: AppColors.dashboardBalanceTrendDotFillColor(
                                context),
                            strokeWidth: 3,
                            strokeColor:
                                AppColors.dashboardBalanceTrendDotBorderColor(
                                    context),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
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
}
