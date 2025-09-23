import 'dart:async';
import 'dart:convert';
import 'package:retail_application/themes/apz_app_themes.dart';
import 'package:retail_application/ui/components/apz_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:retail_application/models/login_stories/apz_story_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  Timer? _navigationTimer;
  int _currentPage = 0;
  late AnimationController _animationController;

  final Duration storyDuration = const Duration(seconds: 5);

  List<Story> _stories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: storyDuration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _goToNextPageOrFinish();
            }
          });

    _loadStories();

    _pageController.addListener(() {
      final currentPage = _pageController.page ?? 0;

      final newPage = currentPage.round();
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
        _startAnimation();
      }
    });
  }

  Future<void> _loadStories() async {
    final String data =
        await rootBundle.loadString('mock/mock_datas/mock_stories.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      _stories = jsonResult.map((e) => Story.fromJson(e)).toList();
      _isLoading = false;
    });
    _startAnimation();
  }

  void _startAnimation() {
    _animationController.stop();
    _animationController.reset();
    _animationController.forward();
  }

  void _goToNextPageOrFinish() {
    if (_currentPage < _stories.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _navigationTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTapLeft() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      _startAnimation();
    }
  }

  void _onTapRight() {
    if (_currentPage < _stories.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      _startAnimation();
    }
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(_stories.length, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.onboardingProgressInactive(context),
              borderRadius: BorderRadius.circular(2),
            ),
            child: index == _currentPage
                ? AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _animationController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.onboarding(context),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  )
                : index < _currentPage
                    ? Container(
                        decoration: BoxDecoration(
                          color: AppColors.onboarding(context),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )
                    : null,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _stories.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              _startAnimation();
            },
            itemBuilder: (context, index) {
              final story = _stories[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(story.imageUrl, fit: BoxFit.cover),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/icon_name1.png',
                          height: 44,
                          width: 208,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 20,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            AppColors.onboardingSkipButtonBg(context),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ApzText(
                            label: 'Skip',
                            fontWeight: ApzFontWeight.headingSemibold,
                            fontSize: 14,
                            color: AppColors.onboarding(context),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.onboarding(context),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ApzText(
                          label: story.title,
                          fontWeight: ApzFontWeight.titlesSemibold,
                          color: AppColors.onboarding(context),
                          fontSize: 26,
                        ),
                        const SizedBox(height: 8),
                        ApzText(
                          label: story.description,
                          fontWeight: ApzFontWeight.labelRegular,
                          color: AppColors.onboarding(context),
                          fontSize: 17,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _onTapLeft,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _onTapRight,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 28,
            left: 20,
            right: 20,
            child: _buildProgressBar(),
          ),
        ],
      ),
    );
  }
}
