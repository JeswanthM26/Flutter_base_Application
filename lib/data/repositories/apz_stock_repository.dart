
import 'package:Retail_Application/core/configs/apz_app_config.dart';
import 'package:Retail_Application/core/utils/apz_api_service.dart';
import 'package:Retail_Application/data/enums/apz_api_enums.dart';
import 'package:Retail_Application/models/api_test/apz_stock_model.dart';

class StockRepository {
  final ApiService apiService = ApiService();

  Future<List<ApzStockModel>> fetchTopGainersLosers() async {
    if (AppConfig.isMock) {
      // If mock enabled, load from local JSON
      // For now, just return an empty list or parse mock file
      return [];
    } else {
      final response = await apiService.request(
        url: "https://www.alphavantage.co/query",
        method: HttpMethod.get,
        headers: {
          "Content-Type": "application/json",
        },
        queryParams: {
          "function": "TOP_GAINERS_LOSERS",
          "apikey": "9QSQMIV2IFKZA17C",
        },
      );

      final gainers = response["top_gainers"] as List<dynamic>? ?? [];
      return gainers.map((e) => ApzStockModel.fromJson(e)).toList();
    }
  }
}
