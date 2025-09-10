class ApzStockModel {
  final String ticker;
  final String price;
  final String changeAmount;
  final String changePercentage;

  ApzStockModel({
    required this.ticker,
    required this.price,
    required this.changeAmount,
    required this.changePercentage,
  });

  factory ApzStockModel.fromJson(Map<String, dynamic> json) {
    return ApzStockModel(
      ticker: json['ticker'] ?? "",
      price: json['price'] ?? "",
      changeAmount: json['change_amount'] ?? "",
      changePercentage: json['change_percentage'] ?? "",
    );
  }
}
