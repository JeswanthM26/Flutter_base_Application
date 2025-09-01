import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:Retail_Application/themes/apz_app_themes.dart';
import 'package:Retail_Application/ui/components/apz_text.dart';
import 'package:Retail_Application/l10n/l10n.dart';

class AuthBaseScreen extends StatefulWidget {
  final Widget bottomOverlay;

  const AuthBaseScreen({super.key, required this.bottomOverlay});

  @override
  State<AuthBaseScreen> createState() => _AuthBaseScreenState();
}

class _AuthBaseScreenState extends State<AuthBaseScreen> {
  late VideoPlayerController _controller;
  String selectedLanguage = 'English';
  final double baseWidth = 375;

  final List<String> languageList = [
    'English',
    'العربية',
    'हिन्दी',
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/login/login_screen_light.mp4')
          ..setLooping(true)
          ..initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCustomLanguageDropdown(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              right: 16,
              top: 70,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 144,
                  decoration: BoxDecoration(
                    color: AppColors.container_box(context),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1A000000),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(languageList.length, (index) {
                      return Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              final localeProvider =
                                  Provider.of<LocaleProvider>(context,
                                      listen: false);

                              if (languageList[index] == 'English') {
                                localeProvider.setLocale(const Locale('en'));
                              } else if (languageList[index] == 'العربية') {
                                localeProvider.setLocale(const Locale('ar'));
                              } else if (languageList[index] == 'हिन्दी') {
                                localeProvider.setLocale(const Locale('hi'));
                              }

                              setState(() {
                                selectedLanguage = languageList[index];
                              });

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              alignment: Alignment.centerLeft,
                              child: ApzText(
                                label: languageList[index],
                                fontWeight: ApzFontWeight.titlesSemibold,
                                fontSize: 14 * (w / baseWidth),
                                color: AppColors.primary_text(context),
                              ),
                            ),
                          ),
                          if (index != languageList.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color:
                                  AppColors.input_field_flag_divider(context),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background video
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(color: Colors.black),
          ),

          // Top header
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.03,
                left: size.width * 0.04,
                right: size.width * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/login/logo_light.png',
                    filterQuality: FilterQuality.high,
                  ),
                  Container(
                    width: size.width * 0.25,
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => _showCustomLanguageDropdown(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 2,
                                  child: ApzText(
                                    label: selectedLanguage,
                                    fontWeight: ApzFontWeight.bodyMedium,
                                    fontSize: 14 * (w / baseWidth),
                                    color: const Color(0x1A000000),
                                  ),
                                ),
                                ApzText(
                                  label: selectedLanguage,
                                  fontWeight: ApzFontWeight.bodyMedium,
                                  fontSize: 14 * (w / baseWidth),
                                  color: AppColors.primary_text(context),
                                ),
                              ],
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.expand_more, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom overlay (passed from Login / Signup / OTP etc.)
          widget.bottomOverlay,
        ],
      ),
    );
  }
}
