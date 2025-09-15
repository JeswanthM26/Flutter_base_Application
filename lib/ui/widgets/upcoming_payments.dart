import 'dart:convert';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:Retail_Application/ui/components/apz_payment.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UpcomingPaymentsCardWidget extends StatefulWidget {
  const UpcomingPaymentsCardWidget({super.key});

  @override
  State<UpcomingPaymentsCardWidget> createState() =>
      _UpcomingPaymentsCardWidgetState();
}

class _UpcomingPaymentsCardWidgetState extends State<UpcomingPaymentsCardWidget>
    with TickerProviderStateMixin {
  bool _isExpanded = true;
  List<Map<String, dynamic>> upcomingPayments = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    final String response =
        await rootBundle.loadString('mock/Dashboard/upcoming_payments.json');
    final jsonResult = json.decode(response);

    final List<dynamic> paymentsJson =
        jsonResult["APZRMB__UpcomingPayments_Res"]["apiResponse"]
            ["ResponseBody"]["responseObj"]["upcomingPayments"];

    final List<Map<String, dynamic>> paymentsList = paymentsJson.map((e) {
      String formattedDate = "";

      if (e["nextExecutionDate"] != null) {
        final dateObj = e["nextExecutionDate"];
        try {
          DateTime date = DateTime(
            dateObj["year"],
            dateObj["month"],
            dateObj["day"],
          );
          // Ensure leading zero for day
          String day = date.day.toString().padLeft(2, '0');
          String month = DateFormat('MMM').format(date); // e.g., "Aug"
          formattedDate = "due on $day $month"; // "due on 01 Aug"
        } catch (ex) {
          formattedDate = ""; // fallback if parsing fails
        }
      }

      return {
        "title": e["billNickName"] ?? "Payment",
        "subtitle": formattedDate,
        "amount": "${e["txnCurrency"] ?? ''} ${e["txnAmt"] ?? 0}",
        "imageUrl": "assets/mock/person.png"
      };
    }).toList();

    setState(() {
      upcomingPayments = paymentsList;
    });
  }

  String formatNumber(int number) {
    return number < 10 ? '0$number' : '$number';
  }

  @override
  Widget build(BuildContext context) {
    final int paymentCount = upcomingPayments.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Payments + Add New header
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ApzText(
            label: "Payments",
            color: AppColors.upcomingPaymentsHeader(context),
            fontSize: 14,
            fontWeight: ApzFontWeight.titlesRegular,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add,
                  size: 24,
                  color: AppColors.upcomingPaymentsAddPaymentBlue(
                      context)), // plus symbol
              const SizedBox(width: 4),
              ApzButton(
                label: "Add a New payment",
                onPressed: () {
                  // TODO: handle add new payment action
                },
                appearance: ApzButtonAppearance.tertiary,
                size: ApzButtonSize.large,
                textColor: AppColors.upcomingPaymentsAddPaymentBlue(context),
              ),
            ],
          )
        ]),
        const SizedBox(height: 12),

        // 🔹 Your existing container
        Container(
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: AppColors.upcomingPaymentsCardBackground(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header: Reminder + Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reminder Section
                  Row(
                    children: [
                      // Gradient number box
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(1.00, 0.50),
                            end: Alignment(-1.24, 0.50),
                            colors: [
                              AppColors.upcomingPaymentsGradientStart(context),
                              AppColors.upcomingPaymentsGradientEnd(context)
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: ApzText(
                            label: formatNumber(paymentCount),
                            color:
                                AppColors.upcomingPaymentsPaymentCount(context),
                            fontSize: 20,
                            fontWeight: ApzFontWeight.headingSemibold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 234,
                        child: ApzText(
                          label:
                              "Remainder: You've got payments scheduled soon",
                          color:
                              AppColors.upcomingPaymentsReminderText(context),
                          fontSize: 12,
                          fontWeight: ApzFontWeight.titlesRegular,
                        ),
                      ),
                    ],
                  ),
                  // Right Arrow Icon (original functionality)
                  IconButton(
                    icon: AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.keyboard_arrow_down, size: 22),
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Divider under header
              Opacity(
                opacity: 0.8,
                child: Divider(
                  thickness: 0.3,
                  color: AppColors.upcomingPaymentsDivider(context),
                  height: 0,
                ),
              ),
              const SizedBox(height: 8),

              // Animated Payment Cards
              AnimatedSize(
                alignment: Alignment.bottomCenter,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: upcomingPayments
                                .map((payment) => Column(
                                      children: [
                                        PaymentCard(
                                          title: payment["title"],
                                          subtitle: payment["subtitle"],
                                          imageUrl: payment["imageUrl"],
                                          actionType:
                                              PaymentCardActionType.button,
                                          buttonLabel:
                                              "Pay ${payment["amount"]}",
                                        ),
                                        const SizedBox(height: 8),
                                        Divider(
                                            thickness: 0.3,
                                            color: AppColors
                                                .upcomingPaymentsDivider(
                                                    context),
                                            height: 0),
                                        const SizedBox(height: 8),
                                      ],
                                    ))
                                .toList(),
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 8),
              // Footer Note
              Row(
                children: [
                  Icon(Icons.info,
                      size: 16,
                      color: AppColors.upcomingPaymentsFooterNote(context)),
                  SizedBox(width: 6),
                  Flexible(
                    child: ApzText(
                      label: "Set up autopay to avoid late fee on bills",
                      color: AppColors.upcomingPaymentsFooterNote(context),
                      fontSize: 11,
                    ),
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
