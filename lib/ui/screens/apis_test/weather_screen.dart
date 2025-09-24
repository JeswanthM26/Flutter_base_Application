import 'package:flutter/material.dart';
import 'package:retail_application/core/utils/apz_api_service.dart';
import 'package:retail_application/data/enums/apz_api_enums.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String errorMessage = "";

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final data = await apiService.request(
        url: "https://api.openweathermap.org/data/2.5/weather",
        method: HttpMethod.get,
        queryParams: {
          "q": "Tirupati",
          "appid": "5dd66c1b41521b08de360138e7209022", // 🔑 Replace with your OpenWeather API key
          "units": "metric"
        },
      );

      setState(() {
        weatherData = data;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather("London"); // 🌍 Default city
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Text("Error: $errorMessage")
                : weatherData != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${weatherData!['name']}",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${weatherData!['main']['temp']} °C",
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            "${weatherData!['weather'][0]['description']}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    : const Text("No data"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => fetchWeather("New York"),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
