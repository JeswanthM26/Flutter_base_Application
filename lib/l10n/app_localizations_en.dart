// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get bankingSimplified => 'Banking Simplified';

  @override
  String get trustedByMillions => 'The way you want. Trusted by Millions';

  @override
  String get getStarted => 'GET STARTED';

  @override
  String get login1 => 'LOGIN';

  @override
  String get links => 'Links';

  @override
  String get faqs => 'FAQ’s';

  @override
  String get calculate => 'Calculate';

  @override
  String get locateUs => 'Locate Us';

  @override
  String get replay => 'Replay';

  @override
  String get contactUs => 'ContactUs';

  @override
  String get exchangeRates => 'ExchangeRates';

  @override
  String get theme => 'Theme';

  @override
  String get login => 'Login';

  @override
  String get newToBank => 'New To Bank?';

  @override
  String get registerNow => 'Register Now';

  @override
  String get username => 'Username';

  @override
  String get enterUsername => 'Enter Username';

  @override
  String get continueLabel => 'CONTINUE';

  @override
  String get troubleLoggingIn => 'TROUBLE LOGGING IN?';

  @override
  String get joinUs => 'JOIN US';

  @override
  String welcomeUser(Object username) {
    return 'Welcome, $username 👋';
  }

  @override
  String notUser(Object username) {
    return 'Not $username?';
  }

  @override
  String get switchUser => 'Switch User';

  @override
  String get mpin => 'MPIN';

  @override
  String get enterMpin => 'Enter MPIN';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter Password';

  @override
  String get loginbtn => 'LOGIN';

  @override
  String get troubleLoggingInbtn => 'TROUBLE LOGGING IN?';

  @override
  String get useFaceID => 'Use Face ID to login';

  @override
  String get useFingerprint => 'Use Fingerprint to login';

  @override
  String get useMpinPassword => 'Use MPIN/Password';

  @override
  String welcomeBackUser(Object username) {
    return 'Welcome back, $username 👋';
  }
}
