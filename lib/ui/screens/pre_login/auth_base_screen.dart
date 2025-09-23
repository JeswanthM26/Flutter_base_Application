import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:retail_application/l10n/l10n.dart';

class AuthBaseScreen extends StatefulWidget {
  final Widget bottomOverlay;

  const AuthBaseScreen({super.key, required this.bottomOverlay});

  @override
  State<AuthBaseScreen> createState() => _AuthBaseScreenState();
}

class _AuthBaseScreenState extends State<AuthBaseScreen> {
  late VideoPlayerController _controller;
  late String selectedLanguage;
  final double baseWidth = 375;

  final List<Locale> languageList = L10n.all;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final videoPath = brightness == Brightness.dark
        ? 'assets/login/login_screen_dark.mp4'
        : 'assets/login/login_screen_light.mp4';

    _controller = VideoPlayerController.asset(videoPath)
      ..setLooping(true)
      ..initialize().then((_) => setState(() {}));

    _controller.play();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLocale = Provider.of<LocaleProvider>(context).locale;
    selectedLanguage = L10n.getLangName(currentLocale.languageCode);

    // Rebuild video if theme changes
    final brightness = Theme.of(context).brightness;
    final currentVideo = brightness == Brightness.dark
        ? 'assets/login/login_screen_dark.mp4'
        : 'assets/login/login_screen_light.mp4';

    if (_controller.dataSource != currentVideo) {
      _controller.pause();
      _controller.dispose();
      _controller = VideoPlayerController.asset(currentVideo)
        ..setLooping(true)
        ..initialize().then((_) => setState(() {}));
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCustomLanguageDropdown(BuildContext context) {
    final size = MediaQuery.of(context).size; // ✅ responsive change
    final w = size.width;
    showDialog(
      context: context,
      barrierColor: AppColors.barrierColor(context),
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              right: size.width * 0.04, // ✅ responsive change
              top: size.height * 0.1, // ✅ responsive change
              child: Material(
                color: AppColors.barrierColor(context),
                child: Container(
                  width: size.width * 0.4, // ✅ responsive change
                  decoration: BoxDecoration(
                    color: AppColors.container_box(context),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.languageDropdownShadow(context),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(languageList.length, (index) {
                      final locale = languageList[index];
                      final langName = L10n.getLangName(locale.languageCode);

                      return Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              final localeProvider =
                                  Provider.of<LocaleProvider>(context,
                                      listen: false);

                              localeProvider.setLocale(locale);

                              setState(() {
                                selectedLanguage = langName;
                              });

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.04, // ✅ responsive
                                vertical: size.height * 0.015, // ✅ responsive
                              ),
                              alignment: Alignment.centerLeft,
                              child: ApzText(
                                label: langName,
                                fontWeight: ApzFontWeight.titlesSemibold,
                                fontSize: 14 * (w / baseWidth),
                                color: AppColors.dropdown(context),
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
    final brightness = Theme.of(context).brightness;

    final logoPath = brightness == Brightness.dark
        ? 'assets/login/logo_dark.png'
        : 'assets/login/logo_light.png';

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
                : Container(color: AppColors.dropdown(context)),
          ),

          // Top header
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.02,
                left: size.width * 0.04,
                right: size.width * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    logoPath,
                    filterQuality: FilterQuality.high,
                    height: size.height * 0.05, // ✅ responsive change
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
                                  top: size.height * 0.003, // ✅ responsive
                                  child: ApzText(
                                    label: selectedLanguage,
                                    fontWeight: ApzFontWeight.bodyMedium,
                                    fontSize: 14 * (w / baseWidth),
                                    color: AppColors.languageDropdownShadow(
                                        context),
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
                            SizedBox(width: size.width * 0.015), // ✅ responsive
                            Icon(Icons.expand_more,
                                size: size.width * 0.06), // ✅ responsive
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
