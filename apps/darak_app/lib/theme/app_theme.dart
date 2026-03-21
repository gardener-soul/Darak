import 'package:flutter/material.dart';

/// Define the application's color palette, typography, and decorations.
/// This file centralizes the "Soft Pop & Claymorphism" design system.

class AppColors {
  // --- Warm & Cozy Palette ---

  // Backgrounds
  static const Color creamWhite = Color(0xFFFFFDF5); // Main background
  static const Color pureWhite = Color(
    0xFFFFFFFF,
  ); // Card background if needed for contrast

  // Primary Actions
  static const Color softCoral = Color(0xFFFF8F8F); // Primary
  static const Color warmTangerine = Color(0xFFFFB74D); // Secondary / Accent

  // Secondary Accents (Pastel)
  static const Color sageGreen = Color(0xFFA7C5BD);
  static const Color skyBlue = Color(0xFFB4E4FF);
  static const Color softLavender = Color(0xFFDCD6F7);

  // Text Colors
  static const Color textDark = Color(
    0xFF4A4A4A,
  ); // Headings / Body (Never pure black)
  static const Color textGrey = Color(0xFF8D8D8D); // Subtitles / Hints

  // UI Elements
  static const Color divider = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFE0E0E0);

  // 역할 배지 텍스트 색상
  static const Color roleAdminText = Color(0xFFCC5555);
  static const Color roleMinisterText = Color(0xFF7C6FCD);
  static const Color roleVillageLeaderText = Color(0xFF5C9186);
  static const Color roleGroupLeaderText = Color(0xFF4A8FA8);

  // --- Claymorphism Specifics ---

  // Shadow color should be a darker, warmer tone of the background
  static const Color clayShadow = Color(0xFFD8D4C0);
  // Highlight color is usually pure white with some opacity
  static const Color clayHighlight = Colors.white;
}

class AppTextStyles {
  // Use a rounded font. Ensure 'Nunito' or similar is added to pubspec.yaml assets or via google_fonts.
  static const String fontFamily = 'Nunito';

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
    height: 1.4,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}

class AppDecorations {
  // --- Claymorphism Shadows ---

  /// Standard Clay Shadow for Cards/Containers
  /// Use this list in `BoxDecoration(boxShadow: ...)`
  static List<BoxShadow> clayShadow = [
    // 1. Dark Shadow (Bottom Right) - Gives depth
    BoxShadow(
      color: AppColors.clayShadow.withValues(alpha: 0.6),
      offset: const Offset(8, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    // 2. Light Highlight (Top Left) - Gives the "soft" raised look
    BoxShadow(
      color: AppColors.clayHighlight,
      offset: const Offset(-8, -8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// A softer shadow for smaller elements like text fields
  static List<BoxShadow> innerInputShadow = [
    // This simulates an inner shadow by using a subtle outer shadow
    // or you can use neomorphism libraries. For standard Flutter,
    // we use a subtle drop shadow for inputs to make them pop *out*
    // or just flat with a border. Let's make them pop out slightly but cleaner.
    BoxShadow(
      color: AppColors.clayShadow.withValues(alpha: 0.4),
      offset: const Offset(4, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// Shadow for Floating Interface Elements
  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: AppColors.softCoral.withValues(alpha: 0.3),
      offset: const Offset(0, 10),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // --- Border Radius ---
  static BorderRadius defaultRadius = BorderRadius.circular(24);
  static BorderRadius cardRadius = BorderRadius.circular(32);
  static BorderRadius buttonRadius = BorderRadius.circular(20);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.creamWhite,
      fontFamily: AppTextStyles.fontFamily,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.softCoral,
        surface: AppColors.creamWhite,
        primary: AppColors.softCoral,
        secondary: AppColors.warmTangerine,
        brightness: Brightness.light,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.buttonLabel, // Used for buttons
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.creamWhite,
        surfaceTintColor: Colors.transparent, // Remove M3 tint
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headlineMedium,
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),

      // Elevated Button Theme (Default)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.softCoral,
          foregroundColor: Colors.white,
          elevation:
              0, // We will use custom decorations usually, but for default:
          shadowColor: AppColors.softCoral.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: AppDecorations.buttonRadius,
          ),
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: AppDecorations.defaultRadius,
          borderSide: BorderSide.none, // Clean look
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDecorations.defaultRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDecorations.defaultRadius,
          borderSide: const BorderSide(color: AppColors.softCoral, width: 2),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 출석 상태별 시맨틱 색상 상수 (앱 전역 SSoT)
// ═══════════════════════════════════════════════════════════════

/// 출석 상태에 따른 색상 토큰.
/// 화면마다 색이 달라지면 인지 부하가 증가하므로
/// 이 클래스를 단일 진실 공급원(SSoT)으로 사용한다.
class AttendanceColors {
  AttendanceColors._();

  // ── 메인 배경·아이콘 색상 ──────────────────────────────────────
  static const Color present  = AppColors.sageGreen;       // #A7C5BD — 긍정·완료
  static const Color late     = AppColors.warmTangerine;   // #FFB74D — 주의·경고
  static const Color absent   = AppColors.softCoral;       // #FF8F8F — 부정·위험
  static const Color excused  = AppColors.softLavender;    // #DCD6F7 — 중립·예외

  // ── 클레이모피즘 하단 솔리드 그림자 색상 ─────────────────────────
  static const Color presentShadow  = Color(0xFF7AA89F);
  static const Color lateShadow     = Color(0xFFE09535);
  static const Color absentShadow   = Color(0xFFD96C6C);
  static const Color excusedShadow  = Color(0xFFB8B0E8);

  /// 출석률에 따른 프로그레스 바 색상 자동 분기.
  /// 80% 이상 → 초록, 50~79% → 주황, 50% 미만 → 빨강
  static Color progressColor(double rate) {
    if (rate >= 0.8) return present;
    if (rate >= 0.5) return late;
    return absent;
  }
}

