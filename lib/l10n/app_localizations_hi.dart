// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get bankingSimplified => 'सरल बैंकिंग';

  @override
  String get trustedByMillions => 'जैसा आप चाहते हैं। लाखों लोगों का विश्वास';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get login => 'लॉगिन';

  @override
  String get links => 'लिंक';

  @override
  String get faqs => 'प्रश्नोत्तर';

  @override
  String get calculate => 'गणना करें';

  @override
  String get locateUs => 'हमें ढूँढें';

  @override
  String get replay => 'फिर से चलाएँ';

  @override
  String get newToBank => 'बैंक में नया?';

  @override
  String get registerNow => 'अभी रजिस्टर करें';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get enterUsername => 'अपना उपयोगकर्ता नाम दर्ज करें';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get troubleLoggingIn => 'लॉगिन में समस्या?';

  @override
  String get joinUs => 'हमसे जुड़ें';

  @override
  String welcomeUser(Object username) {
    return 'स्वागत है, $username 👋';
  }

  @override
  String notUser(Object username) {
    return '$username नहीं हैं?';
  }

  @override
  String get switchUser => 'उपयोगकर्ता बदलें';

  @override
  String get mpin => 'एमपिन';

  @override
  String get enterMpin => 'एमपिन दर्ज करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get enterPassword => 'पासवर्ड दर्ज करें';

  @override
  String get loginbtn => 'लॉगिन';

  @override
  String get troubleLoggingInbtn => 'लॉगिन में समस्या?';

  @override
  String get faceIdDialogTitle =>
      'क्या आप एप्लिकेशन को फेस आईडी उपयोग करने की अनुमति देना चाहते हैं?';

  @override
  String get faceIdDialogMessage =>
      'एप्लिकेशन आपके प्रमाणीकृत करने के लिए फेस आईडी का उपयोग करना चाहता है।';

  @override
  String get faceIdDialogCancel => 'रद्द करें';

  @override
  String get faceIdDialogOk => 'ठीक है';
}
