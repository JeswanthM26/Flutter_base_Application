import 'package:retail_application/ui/components/apz_dropdown.dart';
import 'package:flutter/material.dart';

class ApzDropdownExample extends StatefulWidget {
  const ApzDropdownExample({super.key});

  @override
  State<ApzDropdownExample> createState() => _ApzDropdownExampleState();
}

class _ApzDropdownExampleState extends State<ApzDropdownExample> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = ValueNotifier<String?>('Canada');
  final _cityController = ValueNotifier<String?>(null);
  final _fruitController = ValueNotifier<String?>(null);

  final List<String> _countries = ['India', 'USA', 'Canada', 'UK', 'Australia'];
  final List<String> _cities = ['New York', 'London', 'Mumbai', 'Sydney', 'Toronto'];
  final List<String> _fruits = [
    'Apple', 'Banana', 'Orange', 'Mango', 'Grapes', 'Pineapple', 'Strawberry', 'Blueberry'
  ];

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    _fruitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApzDropdown Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Web Dropdown (Overlay)", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Dropdown with default value
              ApzDropdown(
                label: 'Country',
                items: _countries,
                controller: _countryController,
                defaultValue: 'Canada',
                hintText: 'Select a country',
                variation: ApzDropdownVariation.web,
                onChanged: (value) => debugPrint('Selected Country: $value'),
              ),
              const SizedBox(height: 24),

              // Mandatory and Searchable Dropdown
              ApzDropdown(
                label: 'City',
                items: _cities,
                controller: _cityController,
                hintText: 'Select a city',
                isMandatory: true,
                isSearchable: true,
                variation: ApzDropdownVariation.web,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              const Divider(thickness: 2),
              const SizedBox(height: 24),
              const Text("Mobile Dropdown (Bottom Sheet)", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Mobile variation
              ApzDropdown(
                label: 'Fruit',
                items: _fruits,
                controller: _fruitController,
                hintText: 'Select a fruit',
                isSearchable: true,
                isMandatory: true,
                variation: ApzDropdownVariation.mobile,
              ),
              const SizedBox(height: 24),

              // Disabled Dropdown
              const ApzDropdown(
                label: 'Disabled Field',
                items: ['Option 1', 'Option 2'],
                hintText: 'You cannot select this',
                enabled: false,
              ),
              const SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form is valid!')),
                      );
                    }
                  },
                  child: const Text('Validate Form'),
                ),
              ),
              const SizedBox(height: 16),

              // Display selected values
              ValueListenableBuilder<String?>(
                valueListenable: _countryController,
                builder: (context, value, child) {
                  return Text('Selected Country: ${value ?? 'None'}');
                },
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _cityController,
                builder: (context, value, child) {
                  return Text('Selected City: ${value ?? 'None'}');
                },
              ),
               ValueListenableBuilder<String?>(
                valueListenable: _fruitController,
                builder: (context, value, child) {
                  return Text('Selected Fruit: ${value ?? 'None'}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
