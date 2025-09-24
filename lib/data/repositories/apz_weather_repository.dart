import 'package:retail_application/core/constants/apz_api_constants.dart';
import 'package:retail_application/core/utils/apz_api_service.dart';
import 'package:retail_application/data/enums/apz_api_enums.dart';
// import 'package:http/http.dart' as http;


class ApzWeatherRepository {
  final ApiService apiService;

  ApzWeatherRepository(this.apiService);

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await apiService.request(
      url: ApiConstants.openWeatherBaseUrl,
      method: HttpMethod.get,
      queryParams: {
        "q": city,
        "appid": ApiConstants.apiKey,
        "units": "metric",
      },
    );
    return response;
  }
}
