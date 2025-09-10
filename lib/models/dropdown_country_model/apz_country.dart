class PhoneNumberModel {
  final String countryCode;
  final String phoneNumber;

  PhoneNumberModel({
    required this.countryCode,
    required this.phoneNumber,
  });

  String get fullNumber => "$countryCode$phoneNumber";
}
