import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import 'widgets/onboarding_page.dart';
import 'profile_setup_screen.dart';

/// 앱 소개 온보딩 화면 (PageView 기반 슬라이드)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 온보딩 페이지 데이터
  final List<Map<String, dynamic>> _pages = [
    {
      'title': '다락에 오신 것을 환영합니다',
      'description': '교회 공동체를 위한\n따뜻한 소통 공간',
      'icon': Icons.home_rounded,
      'color': AppColors.softCoral,
    },
    {
      'title': '우리의 이야기를 나눠요',
      'description': '다락방 멤버들과 함께\n일상을 공유하고 소통해요',
      'icon': Icons.people_rounded,
      'color': AppColors.warmTangerine,
    },
    {
      'title': '함께 성장해요',
      'description': '신앙 생활과 일상의 기쁨을\n함께 나누는 공동체',
      'icon': Icons.favorite_rounded,
      'color': AppColors.sageGreen,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _skipOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ProfileSetupScreen(),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _skipOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 건너뛰기 버튼
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    '건너뛰기',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            ),

            // 페이지뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    title: page['title'] as String,
                    description: page['description'] as String,
                    icon: page['icon'] as IconData,
                    iconColor: page['color'] as Color?,
                  );
                },
              ),
            ),

            // 페이지 인디케이터
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.softCoral
                          : AppColors.disabled,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.all(32),
              child: BouncyButton(
                onPressed: _nextPage,
                text: _currentPage == _pages.length - 1 ? '시작하기' : '다음',
                textColor: AppColors.pureWhite,
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
