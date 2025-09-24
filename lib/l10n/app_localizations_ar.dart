// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get bankingSimplified => 'تبسيط الخدمات المصرفية';

  @override
  String get trustedByMillions => 'بالطريقة التي تريدها. موثوق من قبل الملايين';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get login1 => 'تسجيل الدخول';

  @override
  String get links => 'روابط';

  @override
  String get faqs => 'الأسئلة الشائعة';

  @override
  String get calculate => 'احسب';

  @override
  String get locateUs => 'موقعنا';

  @override
  String get replay => 'إعادة';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get exchangeRates => 'أسعار الصرف';

  @override
  String get theme => 'السمة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get newToBank => 'جديد في البنك؟';

  @override
  String get registerNow => 'سجل الآن';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get enterUsername => 'أدخل اسم المستخدم';

  @override
  String get continueLabel => 'استمرار';

  @override
  String get troubleLoggingIn => 'مشكلة في تسجيل الدخول؟';

  @override
  String get joinUs => 'انضم إلينا';

  @override
  String welcomeUser(Object username) {
    return 'مرحبًا، $username 👋';
  }

  @override
  String notUser(Object username) {
    return 'لستَ $username؟';
  }

  @override
  String get switchUser => 'تبديل المستخدم';

  @override
  String get mpin => 'الرمز السري';

  @override
  String get enterMpin => 'أدخل الرمز السري';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get loginbtn => 'تسجيل الدخول';

  @override
  String get troubleLoggingInbtn => 'مشكلة في تسجيل الدخول؟';

  @override
  String get useFaceID => 'استخدم التعرف على الوجه لتسجيل الدخول';

  @override
  String get useFingerprint => 'استخدم بصمة الإصبع لتسجيل الدخول';

  @override
  String get useMpinPassword => 'استخدم الرقم السري الشخصي/كلمة المرور';

  @override
  String welcomeBackUser(Object username) {
    return 'مرحبًا بعودتك، $username 👋';
  }
}
