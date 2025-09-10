import 'package:Retail_Application/ui/components/apz_loader.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';

class ApzLoaderExample extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const ApzLoaderExample({
    Key? key,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppzLoader Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'This loader is activity.'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                ApzLoader.show(context,);
                //const ApzText(label: "Authenticating...")
                  await Future.delayed(const Duration(seconds: 6));
                  Navigator.of(context, rootNavigator: true).pop();
                },
                           child: const Text('Show Loader'),
              ),   
            ],
          ),
        ),
      ),
    );
  }
}

