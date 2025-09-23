import 'dart:convert';
import 'package:retail_application/data/enums/apz_api_enums.dart';
import 'package:http/http.dart' as http;

//enum HttpMethod { get, post, put, delete }

class ApiService {
  Future<Map<String, dynamic>> request({
    required String url,
    required HttpMethod method,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    dynamic body,
  }) async {
    try {
      // Build query string if queryParams exist
      final uri = Uri.parse(url).replace(queryParameters: queryParams);

      http.Response response;

      switch (method) {
        case HttpMethod.get:
          response = await http.get(uri, headers: headers);
          break;
        case HttpMethod.post:
          response = await http.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case HttpMethod.put:
          response = await http.put(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case HttpMethod.delete:
          response = await http.delete(uri, headers: headers);
          break;
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            "API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Request failed: $e");
    }
  }
}
