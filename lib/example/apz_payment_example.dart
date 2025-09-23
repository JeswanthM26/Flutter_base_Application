import 'package:retail_application/ui/components/apz_payment.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_button.dart';

class PaymentCardExample extends StatelessWidget {
  const PaymentCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PaymentCard Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text('Payment Card with Button',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            PaymentCard(
              title: "Aditya Birla Mutual Fund",
              subtitle: "due on 05 Aug",
              imageUrl: "assets/mock/person.png",
              actionType: PaymentCardActionType.button,
              buttonLabel: "Pay ₹5076.83",
              buttonAppearance: ApzButtonAppearance.primary,
              buttonSize: ApzButtonSize.small,
            ),
            const SizedBox(height: 32),
            // const Text('Payment Card with Icon',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            PaymentCard(
              title: "HDFC Bank Account",
              subtitle: "Last synced: today",
              imageUrl: "assets/mock/person.png",
              actionType: PaymentCardActionType.icon,
              icon: Icons.info_outline,
              onIconTap: () {
                debugPrint("Info icon tapped");
              },
            ),
            const SizedBox(height: 32),
            // const Text('Payment Card with Text (Credit)',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            PaymentCard(
              title: "Salary Credit",
              subtitle: "08 Sep 2025",
              imageUrl: "assets/mock/person.png",
              actionType: PaymentCardActionType.text,
              amount: "+ ₹25,000",
              isCredit: true,
            ),
            const SizedBox(height: 32),
            // const Text('Payment Card with Text (Debit)',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            PaymentCard(
              title: "Electricity Bill",
              subtitle: "due on 10 Sep",
              imageUrl: "assets/mock/person.png",
              actionType: PaymentCardActionType.text,
              amount: "- ₹3,200",
              isCredit: false,
            ),
          ],
        ),
      ),
    );
  }
}
