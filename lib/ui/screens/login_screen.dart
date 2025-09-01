import 'package:Retail_Application/ui/components/apz_input_field.dart';
import 'package:flutter/material.dart';
import 'package:Retail_Application/l10n/app_localizations.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_button.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'auth_base_screen.dart';
import 'auth_overlay_container.dart';
import 'package:Retail_Application/ui/components/apz_segment_control.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double baseWidth = 375;

  bool showLoginForm = false;
  bool showMpinForm = false;
  final _nameController = TextEditingController();
  final _mpinController = TextEditingController();
  final _passwordController = TextEditingController();

  int selected = 0; // 0 => MPIN, 1 => Password
  String _enteredUsername = '';
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void dispose() {
    _nameController.dispose();
    _mpinController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool? allowed = prefs.getBool('${_enteredUsername}_biometricAllowed');

    // If permission already allowed, go directly to Face ID authentication
    if (allowed == true) {
      _authenticate();
      return;
    }

    // Show permission dialog if not set
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Biometric Authentication?'),
        content: const Text(
            'Do you want to use Face ID / Fingerprint for future logins?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // user denied
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // user allowed
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Store user choice
    if (result != null) {
      prefs.setBool('${_enteredUsername}_biometricAllowed', result);
    }

    // Go directly to Dashboard even if canceled or allowed
    _goToDashboard();
  }

  Future<void> _authenticate() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        _goToDashboard(); // fallback if device does not support biometrics
        return;
      }

      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        _goToDashboard();
      } else {
        // Authentication failed, fallback to MPIN/password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed!')),
        );
      }
    } catch (e) {
      _goToDashboard(); // fallback on error
    }
  }

  void _goToDashboard() {
    // Replace this with your dashboard navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigated to Dashboard')),
    );
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

    Widget bottomContent = showMpinForm
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ApzText(
                label: local.welcomeUser(_enteredUsername),
                fontWeight: ApzFontWeight.displayHeadingExpandedRegular,
                fontSize: 27 * (w / baseWidth),
                color: AppColors.primary_text(context),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  ApzText(
                    label: local.notUser(_enteredUsername),
                    fontWeight: ApzFontWeight.bodyRegular,
                    fontSize: 16 * (w / baseWidth),
                    color: AppColors.secondary_text(context),
                  ),
                  const SizedBox(width: 4),
                  ApzButton(
                    label: local.switchUser,
                    appearance: ApzButtonAppearance.tertiary,
                    textColor: AppColors.primary_text(context),
                    size: ApzButtonSize.large,
                    onPressed: () {
                      setState(() {
                        showMpinForm = false;
                        showLoginForm = false;
                        _enteredUsername = '';
                        _nameController.clear();
                        _mpinController.clear();
                        _passwordController.clear();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ApzButton(
                  label: local.loginbtn,
                  appearance: ApzButtonAppearance.primary,
                  size: ApzButtonSize.large,
                  onPressed: _handleLogin,
                ),
              ),
              const SizedBox(height: 20),
              ApzButton(
                label: local.troubleLoggingInbtn,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary_text(context),
                size: ApzButtonSize.large,
                onPressed: () {},
              ),
            ],
          )
        : Column(
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
                      label: local.login,
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
            ],
          );

    if (!showMpinForm && showLoginForm) {
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
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ApzText(
                label: local.newToBank,
                fontWeight: ApzFontWeight.bodyRegular,
                fontSize: 16 * (w / baseWidth),
                color: AppColors.secondary_text(context),
              ),
              const SizedBox(width: 4),
              ApzButton(
                label: local.registerNow,
                appearance: ApzButtonAppearance.tertiary,
                textColor: AppColors.primary_text(context),
                size: ApzButtonSize.large,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          ApzInputField(
            label: local.username,
            controller: _nameController,
            hintText: local.enterUsername,
            isMandatory: true,
            allowAllCaps: true,
          ),
          const SizedBox(height: 44),
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
          const SizedBox(height: 24),
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
                textColor: AppColors.secondary(context),
                size: ApzButtonSize.large,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return AuthBaseScreen(
      bottomOverlay: AuthOverlayContainer(child: bottomContent),
    );
  }
}
