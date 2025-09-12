import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';

class HalfDonutChart extends StatelessWidget {
  final String title;
  final String centerText;
  final String percentage;
  final String amount1;
  final String amount2;
  final String date1;
  final String date2;
  final String legend1;
  final String legend2;
  final List<PieChartSectionData> sections;
  final double totalValue;

  const HalfDonutChart({
    Key? key,
    required this.title,
    required this.centerText,
    required this.percentage,
    required this.amount1,
    required this.amount2,
    required this.date1,
    required this.date2,
    required this.legend1,
    required this.legend2,
    required this.sections,
    required this.totalValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF002A4D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ApzText(
            label: title,
            color: const Color(0xFFE6F2FA),
            fontSize: 15,
            fontWeight: ApzFontWeight.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 250,
            height: 125,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0.0, 0.5),
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: 180,
                      sectionsSpace: 2,
                      centerSpaceRadius: 80,
                      sections: [
                        ...sections,
                        // Invisible section to take up the other half
                        PieChartSectionData(
                          value: totalValue,
                          color: Colors.transparent,
                          showTitle: false,
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ApzText(
                        label: percentage,
                        color: const Color(0xFFF5F5F5),
                        fontSize: 22.55,
                        fontWeight: ApzFontWeight.captionSemibold,
                      ),
                      const SizedBox(height: 2),
                      ApzText(
                        label: centerText,
                        color: const Color(0xFFBABABA),
                        fontSize: 11.51,
                        fontWeight: ApzFontWeight.bodyRegular,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ApzText(
                        label: amount1,
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: ApzFontWeight.bodyMedium,
                      ),
                      ApzText(
                        label: date1,
                        color: const Color(0xFFBABABA),
                        fontSize: 11,
                        fontWeight: ApzFontWeight.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ApzText(
                        label: amount2,
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: ApzFontWeight.bodyMedium,
                      ),
                      ApzText(
                        label: date2,
                        color: const Color(0xFFBABABA),
                        fontSize: 11,
                        fontWeight: ApzFontWeight.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(legend1, const [Color(0xFFB3E0FF), Color(0xFFF4F8FF)]),
              const SizedBox(width: 40),
              _buildLegend(legend2, const [Color(0xFFF4F8FF), Color(0xFF5AB8F0)]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String text, List<Color> colors) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.48),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ApzText(
          label: text,
          color: Colors.white,
          fontSize: 13,
          fontWeight: ApzFontWeight.bodyMedium,
        ),
      ],
    );
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:Retail_Application/ui/components/apz_text.dart';

// class HalfDonutChart extends StatelessWidget {
//   final String title;
//   final String centerText;
//   final String percentage;
//   final String amount1;
//   final String amount2;
//   final String date1;
//   final String date2;
//   final String legend1;
//   final String legend2;
//   final List<PieChartSectionData> sections;
//   final double totalValue;

//   const HalfDonutChart({
//     Key? key,
//     required this.title,
//     required this.centerText,
//     required this.percentage,
//     required this.amount1,
//     required this.amount2,
//     required this.date1,
//     required this.date2,
//     required this.legend1,
//     required this.legend2,
//     required this.sections,
//     required this.totalValue,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF002A4D),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           ApzText(
//             label: title,
//             color: const Color(0xFFE6F2FA),
//             fontSize: 15,
//             fontWeight: ApzFontWeight.bodyMedium,
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: 250,
//             height: 125,
//             child: Stack(
//               children: [
//                 PieChart(
//                   PieChartData(
//                     startDegreeOffset: 180,
//                     sectionsSpace: 2,
//                     centerSpaceRadius: 80,
//                     sections: [
//                       ...sections,
//                       // Invisible section to take up the other half
//                       PieChartSectionData(
//                         value: totalValue,
//                         color: Colors.transparent,
//                         showTitle: false,
//                         radius: 50,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Center(
//                   child: Transform.translate(
//                     offset: const Offset(0, -10),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ApzText(
//                           label: percentage,
//                           color: const Color(0xFFF5F5F5),
//                           fontSize: 22.55,
//                           fontWeight: ApzFontWeight.captionSemibold,
//                         ),
//                         ApzText(
//                           label: centerText,
//                           color: const Color(0xFFBABABA),
//                           fontSize: 11.51,
//                           fontWeight: ApzFontWeight.bodyRegular,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ApzText(
//                         label: amount1,
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: ApzFontWeight.bodyMedium,
//                       ),
//                       ApzText(
//                         label: date1,
//                         color: const Color(0xFFBABABA),
//                         fontSize: 11,
//                         fontWeight: ApzFontWeight.bodyMedium,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       ApzText(
//                         label: amount2,
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontWeight: ApzFontWeight.bodyMedium,
//                       ),
//                       ApzText(
//                         label: date2,
//                         color: const Color(0xFFBABABA),
//                         fontSize: 11,
//                         fontWeight: ApzFontWeight.bodyMedium,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildLegend(legend1, const [Color(0xFFB3E0FF), Color(0xFFF4F8FF)]),
//               const SizedBox(width: 40),
//               _buildLegend(legend2, const [Color(0xFFF4F8FF), Color(0xFF5AB8F0)]),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegend(String text, List<Color> colors) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: ShapeDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: colors,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(2.48),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         ApzText(
//           label: text,
//           color: Colors.white,
//           fontSize: 13,
//           fontWeight: ApzFontWeight.bodyMedium,
//         ),
//       ],
//     );
//   }
// }