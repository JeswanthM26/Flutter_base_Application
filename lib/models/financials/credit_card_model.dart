import 'dart:convert';

CreditCardResponse creditCardResponseFromJson(String str) =>
    CreditCardResponse.fromJson(json.decode(str));

class CreditCardResponse {
  final List<CreditCard> creditCards;

  CreditCardResponse({required this.creditCards});

  factory CreditCardResponse.fromJson(Map<String, dynamic> json) {
    var creditCardsList = json['APZRMB__CreditCardDetails_Res']['apiResponse']
        ['ResponseBody']['responseObj']['creditCards'] as List;
    List<CreditCard> creditCards =
        creditCardsList.map((i) => CreditCard.fromJson(i)).toList();
    return CreditCardResponse(creditCards: creditCards);
  }
}

class CreditCard {
  final String cardHolderName;
  final String cardNumber;
  final String currency;
  final double cardBalance;
  final int creditLmt;
  final int availableCredit;

  CreditCard({
    required this.cardHolderName,
    required this.cardNumber,
    required this.currency,
    required this.cardBalance,
    required this.creditLmt,
    required this.availableCredit,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardHolderName: json['cardHolderName'],
      cardNumber: json['cardNumber'],
      currency: json['currency'],
      cardBalance: (json['cardBalance'] as num).toDouble(),
      creditLmt: (json['creditLmt'] as num).toInt(),
      availableCredit: (json['availableCredit'] as num).toInt(),
    );
  }
}
