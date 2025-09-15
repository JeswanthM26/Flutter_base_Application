class BalanceTrendModel {
  final String accountNo;
  final List<Map<String, dynamic>> trend;

  BalanceTrendModel({
    required this.accountNo,
    required this.trend,
  });

  factory BalanceTrendModel.fromJson(Map<String, dynamic> json) {
    return BalanceTrendModel(
      accountNo: json['accountNumber'] ?? '',
      trend: List<Map<String, dynamic>>.from(json['balanceTrend'] ?? []),
    );
  }
}
