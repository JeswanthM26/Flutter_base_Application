import 'package:flutter/material.dart';
import 'package:retail_application/ui/components/apz_button.dart';

class AppzButtonExample extends StatelessWidget {
  const AppzButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzButton Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Primary Buttons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Small'),
            ApzButton(
              label: 'Primary Small butoon ',
              appearance: ApzButtonAppearance.primary,
              size: ApzButtonSize.small,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('Large'),
            ApzButton(
              label: 'Primary Large',
              appearance: ApzButtonAppearance.primary,
              size: ApzButtonSize.large,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('With Leading Icon'),
            ApzButton(
              label: 'Icon',
              appearance: ApzButtonAppearance.primary,
              iconLeading: Icons.add,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('With Trailing Icon'),
            ApzButton(
              // label: 'Icon',
              iconOnly: Icons.check,
              appearance: ApzButtonAppearance.primary,
              // iconTrailing: Icons.arrow_forward,
              //size: AppzButtonSize.large,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('Disabled'),
            ApzButton(
              label: 'Disabled',
              appearance: ApzButtonAppearance.primary,
              disabled: true,
              onPressed: () {},
            ),
            const SizedBox(height: 32),
            const Text('Secondary Buttons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ApzButton(
              label: 'Secondary',
              appearance: ApzButtonAppearance.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: 32),
            const Text('Tertiary Buttons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ApzButton(
              label: 'Tertiary',
              appearance: ApzButtonAppearance.tertiary,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const Text('Tertiary with Icon'),
            ApzButton(
              label: 'Tertiary',
              appearance: ApzButtonAppearance.tertiary,
              iconLeading: Icons.link,
              onPressed: () {},
              textColor: Colors.yellowAccent,
            ),
            const SizedBox(height: 32),
            const Text('Disabled Buttons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ApzButton(
              label: 'Primary Disabled',
              appearance: ApzButtonAppearance.primary,
              size: ApzButtonSize.small,
              disabled: true,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            ApzButton(
              label: 'Secondary Disabled',
              appearance: ApzButtonAppearance.secondary,
              disabled: true,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            ApzButton(
              label: 'Tertiary Disabled',
              appearance: ApzButtonAppearance.tertiary,
              disabled: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
