import 'dart:convert';
 
class PeriodPreset {
  final String label;
  final int days;
  final String? icon;
 
  PeriodPreset({
    required this.label,
    required this.days,
    this.icon,
  });
 
  factory PeriodPreset.fromJson(Map<String, dynamic> json) {
    return PeriodPreset(
      label: json['label'] ?? '',
      days: json['days'] ?? 0,
      icon: json['icon'],
    );
  }
}
 
class FilterItem {
  final String label;
  final String? icon;
 
  FilterItem({
    required this.label,
    this.icon,
  });
 
  factory FilterItem.fromJson(Map<String, dynamic> json) {
    return FilterItem(
      label: json['label'] ?? '',
      icon: json['icon'],
    );
  }
}
 
class FilterConfig {
  final List<FilterItem> categories;
  final List<FilterItem> creditDebitOptions;
  final List<FilterItem> transactionTypes;
  final List<PeriodPreset> periodPresets;
 
  FilterConfig({
    required this.categories,
    required this.creditDebitOptions,
    required this.transactionTypes,
    required this.periodPresets,
  });
 
 factory FilterConfig.fromJson(Map<String, dynamic> json) {
  // If json already points to filters object, use it directly:
  final f = json; // instead of json['filters'] ?? {};
 
  return FilterConfig(
    categories: (f['categories'] as List? ?? [])
        .map((e) => FilterItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    creditDebitOptions: (f['creditDebitOptions'] as List? ?? [])
        .map((e) => FilterItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    transactionTypes: (f['transactionTypes'] as List? ?? [])
        .map((e) => FilterItem.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
    periodPresets: (f['periodPresets'] as List? ?? [])
        .map((e) => PeriodPreset.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );
}
 
 
  /// Helper to parse directly from API response JSON
  static FilterConfig fromApi(Map<String, dynamic> json) {
    final obj = json["apiResponse"]["ResponseBody"]["responseObj"]["filters"];
    return FilterConfig.fromJson(obj);
  }
}
 
 