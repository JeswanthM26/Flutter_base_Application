class CountryModel {
  final String isoCode; // Example: "IN"
  final String name; // Example: "India"
  final String phoneCode; // Example: "91"
  final String flag; // Emoji or asset path (🇮🇳)

  CountryModel({
    required this.isoCode,
    required this.name,
    required this.phoneCode,
    required this.flag,
  });
}
