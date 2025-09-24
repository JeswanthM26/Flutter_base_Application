import 'package:retail_application/ui/components/apz_segment_control.dart';
import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ApzSegmentedControl(
        values: ['Value1', 'option 2'],
        selectedIndex: selected,
        onChanged: (index) {
          setState(() {
            selected = index;
          });
        },
      ),
    );
  }
}
