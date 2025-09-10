class ApzCountryCode {
  final String name;
  final String code;
  final String flag;

  ApzCountryCode({required this.name, required this.code, required this.flag});
}

// Sample list of country codes
final List<ApzCountryCode> sampleCountryCodes = [
  ApzCountryCode(name: 'India', code: '+91', flag: '🇮🇳'),
  ApzCountryCode(name: 'United States', code: '+1', flag: '🇺🇸'),
  ApzCountryCode(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
  ApzCountryCode(name: 'Australia', code: '+61', flag: '🇦🇺'),
  ApzCountryCode(name: 'Canada', code: '+1', flag: '🇨🇦'),
  ApzCountryCode(name: 'Afghanistan', code: '+93', flag: '🇦🇫'),
  ApzCountryCode(name: 'Albania', code: '+355', flag: '🇦🇱'),
  ApzCountryCode(name: 'Algeria', code: '+213', flag: '🇩🇿'),
];
