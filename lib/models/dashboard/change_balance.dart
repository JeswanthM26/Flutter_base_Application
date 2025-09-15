class BalanceTrendModel {
  final String accountNo;
  final List<dynamic> trend;

  BalanceTrendModel({
    required this.accountNo,
    required this.trend,
  });

  factory BalanceTrendModel.fromJson(Map<String, dynamic> json) {
    return BalanceTrendModel(
      accountNo: json['accountNo'] ?? '',
      trend: json['trendDetails'] as List<dynamic>? ?? [],
    );
  }
}
