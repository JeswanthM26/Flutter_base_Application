import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BalanceTrendChart extends StatefulWidget {
  const BalanceTrendChart({super.key});

  @override
  State<BalanceTrendChart> createState() => _BalanceTrendChartState();
}

class _BalanceTrendChartState extends State<BalanceTrendChart> {
  List<Map<String, dynamic>> _data = [];
  FlSpot? touchedSpot;
  List<int> xAxisIndices = [];
  Map<int, String> xAxisLabels = {};
  List<double> yAxisLabels = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    final String response =
        await rootBundle.loadString('mock/Dashboard/balance_mock.json');
    final jsonResult = json.decode(response);
    final list = jsonResult["APZRMB__BalanceTrend_Res"]["apiResponse"]
        ["ResponseBody"]["responseObj"]["balanceTrend"] as List;

    final rawData = list.map((e) {
      return {
        "date": e["date"],
        "balance": double.parse(e["balance"].replaceAll(",", "")),
      };
    }).toList();

    // Get latest date
    DateTime latestDate = rawData
        .map((e) => DateTime.parse(e["date"]))
        .reduce((a, b) => a.isAfter(b) ? a : b);

    // Build X axis indices and labels for "Today" + 4 previous dates approx 7 days apart
    Map<int, String> labels = {};

    // Find indices of the dates closest to these target dates (latestDate and previous 4 weeks)
    List<DateTime> targetDates =
        List.generate(5, (i) => latestDate.subtract(Duration(days: i * 7)))
            .reversed
            .toList();

    List<int> indicesForXAxis = [];
    for (var targetDate in targetDates) {
      // Find closest date in rawData to targetDate
      int closestIndex = 0;
      int minDiff = 1000000;
      for (int i = 0; i < rawData.length; i++) {
        DateTime d = DateTime.parse(rawData[i]["date"]);
        int diff = (d.difference(targetDate).inDays).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestIndex = i;
        }
      }
      indicesForXAxis.add(closestIndex);
    }

    // Remove duplicates and sort ascending
    indicesForXAxis = indicesForXAxis.toSet().toList()..sort();

    for (var index in indicesForXAxis) {
      final date = DateTime.parse(rawData[index]["date"]);
      if (date == latestDate) {
        labels[index] = "Today";
      } else {
        final formattedDay = date.day.toString().padLeft(2, '0');
        labels[index] = "$formattedDay'${_monthName(date.month)}";
      }
    }

    // Prepare Y axis labels - max balance rounding
    double maxBalance = rawData
        .map((e) => e["balance"] as double)
        .reduce((a, b) => a > b ? a : b);

    // Round maxBalance up to next 1000
    double maxY = (maxBalance / 1000).ceil() * 1000;

    // Define 3 equal Y axis label steps
    double yStep = maxY / 3;
    List<double> yLabels = [yStep, 2 * yStep, maxY];

    setState(() {
      _data = rawData;
      xAxisIndices = indicesForXAxis;
      xAxisLabels = labels;
      yAxisLabels = yLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final chartWidth = screenWidth;
    final double chartHeight =
        220; // increased height for better label visibility

    return SizedBox(
      width: chartWidth,
      height: chartHeight,
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
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              tooltipMargin: 10,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    "${(spot.y ~/ 1000)}k",
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  );
                }).toList();
              },
            ),
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
                interval: yAxisLabels.isNotEmpty
                    ? yAxisLabels.first
                    : 1000, // interval matches yStep
                getTitlesWidget: (value, meta) {
                  // Show only the specific Y labels within a small tolerance
                  bool show = yAxisLabels.any((element) =>
                      (element - value).abs() < yAxisLabels.first * 0.1);
                  return show
                      ? Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            "${(value ~/ 1000)}k",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
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
                interval: 1, // Force showing titles for each integer index
                reservedSize: 48,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (xAxisLabels.containsKey(index)) {
                    final label = xAxisLabels[index]!;
                    if (label == "Today") {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Today",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
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
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF4A90E2)],
              ),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4A90E2).withOpacity(0.14),
                    Colors.transparent,
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
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: const Color(0xFF4A90E2),
                  );
                },
              ),
            ),
          ],
        ),
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
}
