import 'package:Retail_Application/ui/components/apz_payment.dart';
import 'package:flutter/material.dart';

class UpcomingPaymentsCard extends StatelessWidget {
  const UpcomingPaymentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      // spacing below chart
      decoration: ShapeDecoration(
        color: const Color(0xFFEDF2FA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
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
              const Icon(Icons.close, size: 20),
            ],
          ),

          const Divider(thickness: 0.3, color: Color(0x6668696A)),

          // 🔹 Payment Cards
          PaymentCard(
            title: "Credit Card Bill - 4560",
            subtitle: "Due on 01 Aug",
            imageUrl: "assets/icons/creditcard.png",
            actionType: PaymentCardActionType.button,
            buttonLabel: "Pay \$27,230.00",
          ),

          const Divider(thickness: 0.3, color: Color(0x6668696A)),

          PaymentCard(
            title: "Aditya Birla Mutual Fund",
            subtitle: "Due on 05 Aug",
            imageUrl: "assets/icons/mutualfund.png",
            actionType: PaymentCardActionType.button,
            buttonLabel: "Pay \$5,076.83",
          ),

          const Divider(thickness: 0.3, color: Color(0x6668696A)),
          PaymentCard(
            title: "Aditya Birla Mutual Fund",
            subtitle: "Due on 05 Aug",
            imageUrl: "assets/icons/mutualfund.png",
            actionType: PaymentCardActionType.icon,
            icon: Icons.info_outline,
            // buttonLabel: "Pay \$5,076.83",
          ),
          const Divider(thickness: 0.3, color: Color(0x6668696A)),
          PaymentCard(
            title: "Aditya Birla Mutual Fund",
            subtitle: "Due on 05 Aug",
            imageUrl: "assets/icons/mutualfund.png",
            actionType: PaymentCardActionType.text,
            amount: "+ ₹25,000",
            isCredit: true,

            // buttonLabel: "Pay \$5,076.83",
          ),

          // 🔹 Footer Note
          Row(
            children: const [
              Icon(Icons.info, size: 16, color: Color(0xFFFFCB55)),
              SizedBox(width: 6),
              Text(
                "Set up autopay to avoid late fee on bills",
                style: TextStyle(
                  color: Color(0xFFFFCB55),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
