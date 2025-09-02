import 'package:Retail_Application/ui/components/apz_input_field.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/l10n/app_localizations.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:flutter_svg/svg.dart';
import 'auth_base_screen.dart';
import 'auth_overlay_container.dart';
import 'package:Retail_Application/ui/components/apz_segment_control.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double baseWidth = 375;

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
            color: const Color(0xFF131927),
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
          Row(
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
          Row(
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
            SizedBox(height: 12),
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
          Row(
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
          SizedBox(height: 20),

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

          SizedBox(height: 40),

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
                    showBiometricForm = true;
                    cameFromBiometric = false; // reset the flag
                  });
                },
              ),
            ),
          SizedBox(height: 10),
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
          SizedBox(height: 16),
        ],
      );
    } else {
      // Initial welcome screen
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
              children: [
                buildNavItem(context, Icons.link, local.links, w, () {}),
                SizedBox(width: 32 * (w / baseWidth)),
                buildNavItem(context, Icons.help_outline, local.faqs, w, () {}),
                SizedBox(width: 32 * (w / baseWidth)),
                buildNavItem(
                    context, Icons.calculate, local.calculate, w, () {}),
                SizedBox(width: 32 * (w / baseWidth)),
                buildNavItem(context, Icons.location_on_outlined,
                    local.locateUs, w, () {}),
                SizedBox(width: 32 * (w / baseWidth)),
                buildNavItem(context, Icons.replay, local.replay, w, () {}),
              ],
            ),
          ),
          SizedBox(height: h * 0.045),
        ],
      );
    }

    return AuthBaseScreen(
      bottomOverlay: AuthOverlayContainer(child: bottomContent),
    );
  }
}
