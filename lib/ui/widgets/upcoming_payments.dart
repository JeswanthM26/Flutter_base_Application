import 'package:Retail_Application/ui/components/apz_payment.dart';
import 'package:flutter/material.dart';

class UpcomingPaymentsCard extends StatefulWidget {
  const UpcomingPaymentsCard({super.key});

  @override
  State<UpcomingPaymentsCard> createState() => _UpcomingPaymentsCardState();
}

class _UpcomingPaymentsCardState extends State<UpcomingPaymentsCard>
    with TickerProviderStateMixin {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: const Color(0xFFEDF2FA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Header (always fixed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.notifications_active,
                            color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Upcoming Payments",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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

                // 🔹 Animated body (only this collapses)
                AnimatedSize(
                  alignment: Alignment.bottomCenter,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: _isExpanded
                      ? Column(
                          children: [
                            const Divider(
                                thickness: 0.3, color: Color(0x6668696A)),
                            PaymentCard(
                              title: "Credit Card Bill - 4560",
                              subtitle: "Due on 01 Aug",
                              imageUrl: "assets/icons/creditcard.png",
                              actionType: PaymentCardActionType.button,
                              buttonLabel: "Pay \$27,230.00",
                            ),
                            const Divider(
                                thickness: 0.3, color: Color(0x6668696A)),
                            PaymentCard(
                              title: "Aditya Birla Mutual Fund",
                              subtitle: "Due on 05 Aug",
                              imageUrl: "assets/icons/mutualfund.png",
                              actionType: PaymentCardActionType.button,
                              buttonLabel: "Pay \$5,076.83",
                            ),
                            const Divider(
                                thickness: 0.3, color: Color(0x6668696A)),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                // 🔹 Footer Note (always fixed at bottom of card)
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.info, size: 16, color: Color(0xFFFFCB55)),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Set up autopay to avoid late fee on bills",
                        style: TextStyle(
                          color: Color(0xFFFFCB55),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
