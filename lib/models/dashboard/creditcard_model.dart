class CreditCardModel {
  final String cardNumber;
  final String cardType;
  final String currency;
  final double availableCredit;
  final double cardBalance;

  CreditCardModel({
    required this.cardNumber,
    required this.cardType,
    required this.currency,
    required this.availableCredit,
    required this.cardBalance,
  });

  factory CreditCardModel.fromJson(Map<String, dynamic> json) {
    return CreditCardModel(
      cardNumber: json['cardNumber'] ?? "",
      cardType: json['cardType'] ?? "Credit Card",
      currency: json['currency'] ?? "INR",
      availableCredit: (json['availableCredit'] ?? 0).toDouble(),
      cardBalance: (json['cardBalance'] ?? 0).toDouble(),
    );
  }
}
