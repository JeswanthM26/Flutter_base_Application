import 'package:retail_application/core/utils/apz_api_service.dart';
import 'package:retail_application/data/enums/apz_api_enums.dart';
import 'package:flutter/material.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _data;
  bool _loading = false;
  String? _error;

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _apiService.request(
        url: "https://www.alphavantage.co/query",
        method: HttpMethod.get,
        queryParams: {
          "function": "TOP_GAINERS_LOSERS",
          "apikey": "9QSQMIV2IFKZA17C",
        },
      );

      setState(() {
        _data = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Top Gainers & Losers")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
                ? Text("Error: $_error")
                : _data == null
                    ? ElevatedButton(
                        onPressed: _fetchData, child: const Text("Fetch Data"))
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text("API Response:",
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 10),
                          Text(_data.toString()), // 👀 Raw dump
                        ],
                      ),
      ),
    );
  }
}
