import 'package:retail_application/ui/components/apz_searchbar.dart';
import 'package:flutter/material.dart';

class SearchBarDemoPage extends StatefulWidget {
  const SearchBarDemoPage({super.key});

  @override
  State<SearchBarDemoPage> createState() => _SearchBarDemoPageState();
}

class _SearchBarDemoPageState extends State<SearchBarDemoPage> {
  final TextEditingController secondaryController = TextEditingController();

  // 🟢 Demo data for search
  final List<String> contacts = [
    'Alice Johnson',
    'Bob James',
    'Charlie Green',
    'David Lee',
    'Eva Adams',
    'Fiona Carter',
    'George Williams',
    'Hannah Smith',
    'Ivy Brown'
  ];
  List<String> filtered = [];

  // Demo recommendations
  final List<String> keywordSuggestions = [
    "Alice",
    "David",
    "Smith",
    "Williams",
    "Brown"
  ];

  // Demo categories widget:
  Widget get categoriesWidget => Wrap(
        spacing: 8,
        children: [
          ChoiceChip(label: Text("All"), selected: true),
          ChoiceChip(label: Text("Favorites"), selected: false),
          ChoiceChip(label: Text("Recent"), selected: false),
        ],
      );

  void _onFiltered(List<dynamic> items) {
    setState(() {
      filtered = List<String>.from(items);
    });
  }

  @override
  void dispose() {
    secondaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 13, 13, 13),
      appBar: AppBar(title: const Text('SearchBar Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApzSearchBar(
              type: AppzSearchBarType.primary,
              placeholder: 'Search contacts',
              controller: secondaryController,
              trailingIcon: const Icon(Icons.mic),
              onTrailingPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mic icon pressed')),
                );
              },
              items: contacts,
              labelSelector: (item) => item.toString(),
              onFiltered: _onFiltered,
              recommendations: keywordSuggestions,
              categoriesWidget: categoriesWidget,
            ),
            const SizedBox(height: 24),

            // Display filtered search results
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text("No results"))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, idx) =>
                          ListTile(title: Text(filtered[idx])),
                    ),
            ),

            ApzSearchBar(
              type: AppzSearchBarType.secondary,
              placeholder: 'Search products',
              trailingIcon: const Icon(Icons.mic),
              onTrailingPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mic icon pressed')),
                );
              },
              // No extra advanced filtering here
            ),
          ],
        ),
      ),
    );
  }
}
