import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:retail_application/models/login/navItems_model.dart';
import 'package:retail_application/themes/apz_theme_provider.dart';
import 'package:retail_application/ui/components/apz_input_field.dart';
import 'package:flutter/material.dart';
import 'package:retail_application/l10n/app_localizations.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/ui/components/apz_button.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../pre_login/auth_base_screen.dart';
import '../pre_login/auth_overlay_container.dart';
import 'package:retail_application/ui/components/apz_segment_control.dart';
import 'package:local_auth/local_auth.dart';

Future<Map<String, dynamic>> _loadMenuData() async {
  final String data = await rootBundle.loadString('mock/login/navItems.json');
  final jsonResult = json.decode(data);
  return jsonResult['MenuScreen_Res']['apiResponse']['ResponseBody']
      ['responseObj'];
}

// Convert JSON to List<MenuItemModel>
Future<List<MenuItemModel>> loadMenuItems() async {
  final obj = await _loadMenuData();
  final items = obj['menuItems'] as List<dynamic>? ?? [];
  return items.map((item) => MenuItemModel.fromJson(item)).toList();
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double baseWidth = 375;
  List<MenuItemModel> menuItems = [];
  bool isMenuLoading = true;

  bool showLoginForm = false;
  bool showMpinForm = false;
  bool showBiometricForm = false;
  bool showSuccessPage = false;
  bool cameFromBiometric = false;

  final _nameController = TextEditingController();
  final _mpinController = TextEditingController();
  final _passwordController = TextEditingController();

  int selected = 0; // 0 => MPIN, 1 => Password
  String _enteredUsername = '';

  final LocalAuthentication auth = LocalAuthentication();
  BiometricType? _availableBiometric;

  @override
  void initState() {
    super.initState();
    _checkAvailableBiometrics();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    menuItems = await loadMenuItems();
    setState(() {
      isMenuLoading = false;
    });
  }

  Future<void> _checkAvailableBiometrics() async {
    try {
      final biometrics = await auth.getAvailableBiometrics();
      if (biometrics.contains(BiometricType.face)) {
        setState(() {
          _availableBiometric = BiometricType.face;
        });
      } else if (biometrics.contains(BiometricType.fingerprint)) {
        setState(() {
          _availableBiometric = BiometricType.fingerprint;
        });
      } else {
        setState(() {
          _availableBiometric = BiometricType.fingerprint;
        });
      }
    } catch (e) {
      debugPrint("Biometric check failed: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mpinController.dispose();
    _password_controller_dispose_guard();
    super.dispose();
  }

  void _password_controller_dispose_guard() {
    try {
      _passwordController.dispose();
    } catch (_) {}
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        if (mounted) {
          setState(() {
            showBiometricForm = false;
            showMpinForm = false;
            showLoginForm = false;
            showSuccessPage = true; // ✅ go to success page
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Authentication failed")),
          );
        }
      }
    } catch (e) {
      debugPrint("Biometric error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  Widget buildNavItem(BuildContext context, IconData icon, String label,
      double w, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24 * (w / baseWidth),
            color: AppColors.primary_text(context),
          ),
          const SizedBox(height: 10),
          ApzText(
            label: label,
            fontWeight: ApzFontWeight.titlesSemibold,
            fontSize: 10 * (w / baseWidth),
            color: AppColors.primary_text(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    String biometricLabel;
    String biometricAsset;
    if (_availableBiometric == BiometricType.face) {
      biometricLabel = local.useFaceID;
      biometricAsset = "assets/mock/faceid.svg";
    } else if (_availableBiometric == BiometricType.fingerprint) {
      biometricLabel = local.useFingerprint;
      biometricAsset = "assets/mock/fingerprint.svg";
    } else {
      biometricLabel = local.useFingerprint;
      biometricAsset = "assets/mock/fingerprint.svg";
    }

    Widget bottomContent;
    if (showBiometricForm) {
      bottomContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/mock/person.png"),
          ApzText(
            label: local.welcomeBackUser(_enteredUsername),
            fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
            fontSize: 27 * (w / baseWidth),
            color: AppColors.primary_text(context),
          ),
          SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Expanded(
                child: ApzText(
                  label: local.notUser(_enteredUsername),
                  fontWeight: ApzFontWeight.bodyRegular,
                  fontSize: 16 * (w / baseWidth),
                  color: AppColors.secondary_text(context),
                ),
              ),
              SizedBox(width: 4),
              ApzButton(
                label: local.switchUser,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary_text(context),
                size: ApzButtonSize.large,
                onPressed: () {
                  setState(() {
                    showMpinForm = false;
                    showLoginForm = false;
                    showBiometricForm = false;
                    showSuccessPage = false;
                    _enteredUsername = '';
                    _nameController.clear();
                    _mpinController.clear();
                    _passwordController.clear();
                    cameFromBiometric = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                ApzText(
                  label: biometricLabel,
                  fontWeight: ApzFontWeight.bodyMedium,
                  fontSize: 14 * (w / baseWidth),
                  color: AppColors.secondary_text(context),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: _authenticateWithBiometrics,
                  child: SvgPicture.asset(
                    biometricAsset,
                    width: 64,
                    height: 64,
                  ),
                ),
                const SizedBox(height: 20),
                ApzButton(
                  label: local.useMpinPassword,
                  appearance: ApzButtonAppearance.tertiary,
                  size: ApzButtonSize.large,
                  onPressed: () {
                    setState(() {
                      showBiometricForm = false;
                      showMpinForm = true;
                      cameFromBiometric = true;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ApzButton(
            label: local.troubleLoggingInbtn,
            appearance: ApzButtonAppearance.tertiary,
            textColor: AppColors.primary_text(context),
            size: ApzButtonSize.large,
            onPressed: () {},
          ),
        ],
      );
    } else if (showSuccessPage) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && showSuccessPage) {
          context.go('/dashboard');
        }
      });
      bottomContent = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/mock/person.png"),
          ApzText(
            label: local.welcomeBackUser(_enteredUsername),
            fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
            fontSize: 30 * (w / baseWidth),
            color: AppColors.primary_text(context),
          ),
          SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ApzText(
                label: local.notUser(_enteredUsername),
                fontWeight: ApzFontWeight.bodyRegular,
                fontSize: 16 * (w / baseWidth),
                color: AppColors.secondary_text(context),
              ),
              SizedBox(width: 4),
              ApzButton(
                label: local.switchUser,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary_text(context),
                size: ApzButtonSize.large,
                onPressed: () {
                  setState(() {
                    showMpinForm = false;
                    showLoginForm = false;
                    showBiometricForm = false;
                    showSuccessPage = false;
                    _enteredUsername = '';
                    _nameController.clear();
                    _mpinController.clear();
                    _passwordController.clear();
                    cameFromBiometric = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                ApzText(
                  label: biometricLabel,
                  fontWeight: ApzFontWeight.bodyMedium,
                  fontSize: 14 * (w / baseWidth),
                  color: AppColors.secondary_text(context),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  //  onTap:
                  child: SvgPicture.asset(
                    "assets/mock/checkmark.svg",
                    width: 68,
                    height: 68,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ApzButton(
            label: local.troubleLoggingInbtn,
            appearance: ApzButtonAppearance.tertiary,
            textColor: AppColors.primary_text(context),
            size: ApzButtonSize.large,
            onPressed: () {},
          ),
        ],
      );
    } else if (showMpinForm) {
      bottomContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Show image and "Welcome back" only if coming from biometric
          if (cameFromBiometric) ...[
            Image.asset("assets/mock/person.png"),
            SizedBox(height: 6),
            ApzText(
              label: local.welcomeBackUser(_enteredUsername),
              fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
              fontSize: 27 * (w / baseWidth),
              color: AppColors.primary_text(context),
            ),
          ] else
            ApzText(
              label: local.welcomeUser(_enteredUsername),
              fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
              fontSize: 27 * (w / baseWidth),
              color: AppColors.primary_text(context),
            ),

          SizedBox(height: 4),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ApzText(
                label: local.notUser(_enteredUsername),
                fontWeight: ApzFontWeight.bodyRegular,
                fontSize: 16 * (w / baseWidth),
                color: AppColors.secondary_text(context),
              ),
              SizedBox(width: 4),
              ApzButton(
                label: local.switchUser,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary_text(context),
                size: ApzButtonSize.large,
                onPressed: () {
                  setState(() {
                    showMpinForm = false;
                    showLoginForm = false;
                    showBiometricForm = false;
                    showSuccessPage = false;
                    _enteredUsername = '';
                    _nameController.clear();
                    _mpinController.clear();
                    _passwordController.clear();
                    cameFromBiometric = false;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),

          // Segmented control (MPIN / Password)
          Center(
            child: ApzSegmentedControl(
              values: [local.mpin, local.password],
              selectedIndex: selected,
              onChanged: (index) {
                setState(() {
                  selected = index;
                });
              },
            ),
          ),

          SizedBox(height: 16),

          if (selected == 0)
            ApzInputField(
              label: local.mpin,
              controller: _mpinController,
              hintText: local.enterMpin,
              obscureText: true,
              isMandatory: true,
            )
          else
            ApzInputField(
              label: local.password,
              controller: _passwordController,
              hintText: local.enterPassword,
              obscureText: true,
              isMandatory: true,
            ),

          SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ApzButton(
              label: local.loginbtn,
              appearance: ApzButtonAppearance.primary,
              size: ApzButtonSize.large,
              onPressed: () {
                setState(() {
                  showBiometricForm = true; // go to biometric screen
                });
              },
            ),
          ),
          if (cameFromBiometric)
            Center(
              child: ApzButton(
                label: local.useFaceID,
                appearance: ApzButtonAppearance.tertiary,
                size: ApzButtonSize.large,
                onPressed: () {
                  setState(() {
                    showMpinForm = false;
                    showSuccessPage = true;
                    cameFromBiometric = false; // reset the flag
                  });
                },
              ),
            ),
          SizedBox(height: 5),
          ApzButton(
            label: local.troubleLoggingInbtn,
            appearance: ApzButtonAppearance.tertiary,
            textColor: AppColors.primary_text(context),
            size: ApzButtonSize.large,
            onPressed: () {
              // Handle Trouble Logging In
            },
          ),
        ],
      );
    } else if (showLoginForm) {
      // Login form
      bottomContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            child: ApzText(
              label: local.login,
              fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
              fontSize: 34 * (w / baseWidth),
              color: AppColors.primary_text(context),
            ),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ApzText(
                label: local.newToBank,
                fontWeight: ApzFontWeight.bodyRegular,
                fontSize: 16 * (w / baseWidth),
                color: AppColors.secondary_text(context),
              ),
              SizedBox(width: 4),
              ApzButton(
                label: local.registerNow,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary_text(context),
                size: ApzButtonSize.large,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),
          ApzInputField(
            label: local.username,
            controller: _nameController,
            hintText: local.enterUsername,
            isMandatory: true,
            allowAllCaps: true,
          ),
          SizedBox(height: 44),
          SizedBox(
            width: double.infinity,
            child: ApzButton(
              label: local.continueLabel,
              appearance: ApzButtonAppearance.primary,
              size: ApzButtonSize.large,
              onPressed: () {
                setState(() {
                  _enteredUsername = _nameController.text.trim();
                  showMpinForm = true;
                });
              },
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ApzButton(
                label: local.troubleLoggingIn,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary_text(context),
                size: ApzButtonSize.large,
                onPressed: () {},
              ),
              ApzButton(
                label: local.joinUs,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary(context),
                size: ApzButtonSize.large,
                onPressed: () {},
              ),
            ],
          ),
          // SizedBox(height: 16),
        ],
      );
    } else {
      // Add this mapping for icons and labels
      final Map<String, IconData> iconMap = {
        "FAQ": Icons.help_outline,
        "Calculator": Icons.calculate,
        "Replay": Icons.replay,
        "LocateUs": Icons.location_on_outlined,
        "ContactUs": Icons.contact_page,
        "ExchangeRates": Icons.currency_exchange,
        "Theme": Icons.brightness_6,
      };

      Map<String, String> labelMap(AppLocalizations local) => {
            "LIT_FAQ": local.faqs,
            "LIT_CALCULATOR": local.calculate,
            "LIT_REPLAY": local.replay,
            "LIT_LOCATE_US": local.locateUs,
            "LIT_CONTACT_US": local.contactUs,
            "LIT_EXCHANGE_RATE": local.exchangeRates,
            "LIT_THEME": local.theme,
          };

      // Initial welcome screen
      // Initial welcome screen bottomContent
      bottomContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApzText(
                  label: local.bankingSimplified,
                  fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
                  fontSize: 34 * (w / baseWidth),
                  color: AppColors.primary_text(context),
                ),
                const SizedBox(height: 12),
                ApzText(
                  label: local.trustedByMillions,
                  fontWeight: ApzFontWeight.bodyRegular,
                  fontSize: 16 * (w / baseWidth),
                  color: AppColors.secondary_text(context),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.05),
          Row(
            children: [
              Expanded(
                child: ApzButton(
                  label: local.getStarted,
                  appearance: ApzButtonAppearance.primary,
                  size: ApzButtonSize.large,
                  onPressed: () {},
                ),
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: ApzButton(
                  label: local.login1,
                  appearance: ApzButtonAppearance.secondary,
                  size: ApzButtonSize.large,
                  onPressed: () {
                    setState(() {
                      showLoginForm = true;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.045),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: menuItems.map((item) {
                final iconData = iconMap[item.screenID] ?? Icons.link;
                final label = labelMap(local)[item.menu] ?? item.menu;

                if (item.screenID == "Theme") {
                  // 🎨 special case for theme toggle
                  return Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () => themeProvider.toggleTheme(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  themeProvider.themeMode == ThemeMode.dark
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  size: 24 * (w / baseWidth),
                                  color: AppColors.primary_text(context),
                                ),
                                const SizedBox(height: 10),
                                ApzText(
                                  label: label,
                                  fontWeight: ApzFontWeight.titlesSemibold,
                                  fontSize: 10 * (w / baseWidth),
                                  color: AppColors.primary_text(context),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 32 * (w / baseWidth)),
                        ],
                      );
                    },
                  );
                }

                // ✅ default nav item
                return Row(
                  children: [
                    buildNavItem(
                      context,
                      iconData,
                      label,
                      w,
                      () => context.go(item.appID),
                    ),
                    SizedBox(width: 32 * (w / baseWidth)),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(height: h * 0.045),
        ],
      );
    }

    return AuthBaseScreen(
      bottomOverlay: AuthOverlayContainer(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: bottomContent,
        ),
      ),
    );
  }
}
