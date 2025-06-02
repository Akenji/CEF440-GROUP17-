import 'package:flutter/material.dart';

/// App Theme Constants for Mobile Attendance Management System
/// Contains all colors, typography, dimensions, and UI constants
class AppTheme {
  // ==================== COLOR PALETTE ====================

  // Primary Colors
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color primaryBlueDark = Color(0xFF1E40AF);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color accentBlue = Color(0xFF60A5FA);

  // Secondary Colors
  static const Color secondaryGreen = Color(0xFF10B981);
  static const Color secondaryGreenLight = Color(0xFF34D399);
  static const Color secondaryGreenDark = Color(0xFF059669);

  // Success Colors
  static const Color successGreen = Color(0xFF22C55E);
  static const Color successGreenLight = Color(0xFFDCFCE7);
  static const Color successGreenDark = Color(0xFF16A34A);

  // Error/Danger Colors
  static const Color errorRed = Color(0xFFEF4444);
  static const Color errorRedLight = Color(0xFFFEE2E2);
  static const Color errorRedDark = Color(0xFFDC2626);

  // Warning Colors
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color warningOrangeLight = Color(0xFFFEF3C7);
  static const Color warningOrangeDark = Color(0xFFD97706);

  // Info Colors
  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color infoBlueLight = Color(0xFFDBEAFE);
  static const Color infoBlueDark = Color(0xFF2563EB);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF334155);
  static const Color cardElevated = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFF1F2937);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF9CA3AF);

  // Attendance Status Colors
  static const Color presentGreen = Color(0xFF059669);
  static const Color absentRed = Color(0xFFDC2626);
  static const Color lateOrange = Color(0xFFD97706);
  static const Color excusedBlue = Color(0xFF2563EB);

  // Role-based Colors
  static const Color studentBlue = Color(0xFF3B82F6);
  static const Color educatorPurple = Color(0xFF8B5CF6);
  static const Color adminGold = Color(0xFFF59E0B);

  // Camera & Recognition Colors
  static const Color cameraOverlay = Color(0x80000000);
  static const Color faceDetectionGreen = Color(0xFF10B981);
  static const Color faceDetectionRed = Color(0xFFEF4444);

  // Geofence Colors
  static const Color geofenceActive = Color(0xFF10B981);
  static const Color geofenceInactive = Color(0xFFEF4444);
  static const Color geofenceBoundary = Color(0xFF3B82F6);

  // ==================== GRADIENTS ====================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [successGreen, secondaryGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorRed, errorRedDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundLight, grey50],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [white, grey50],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== TYPOGRAPHY ====================

  // Font Families
  static const String primaryFontFamily = 'Inter';
  static const String secondaryFontFamily = 'Roboto';
  static const String displayFontFamily = 'Poppins';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Font Sizes
  static const double fontSize10 = 10.0;
  static const double fontSize12 = 12.0;
  static const double fontSize14 = 14.0;
  static const double fontSize16 = 16.0;
  static const double fontSize18 = 18.0;
  static const double fontSize20 = 20.0;
  static const double fontSize24 = 24.0;
  static const double fontSize28 = 28.0;
  static const double fontSize32 = 32.0;
  static const double fontSize36 = 36.0;
  static const double fontSize40 = 40.0;
  static const double fontSize48 = 48.0;

  // Text Styles
  static const TextStyle displayLarge = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: fontSize48,
    fontWeight: bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: fontSize40,
    fontWeight: bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: displayFontFamily,
    fontSize: fontSize36,
    fontWeight: bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize32,
    fontWeight: bold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize28,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize24,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize20,
    fontWeight: semiBold,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize18,
    fontWeight: medium,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize16,
    fontWeight: medium,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize16,
    fontWeight: regular,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize14,
    fontWeight: regular,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize12,
    fontWeight: regular,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize14,
    fontWeight: medium,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize12,
    fontWeight: medium,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: fontSize10,
    fontWeight: medium,
    color: textTertiary,
    height: 1.4,
  );

  // ==================== DIMENSIONS ====================

  // Spacing
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // Padding
  static const EdgeInsets paddingXS = EdgeInsets.all(spacing4);
  static const EdgeInsets paddingS = EdgeInsets.all(spacing8);
  static const EdgeInsets paddingM = EdgeInsets.all(spacing16);
  static const EdgeInsets paddingL = EdgeInsets.all(spacing24);
  static const EdgeInsets paddingXL = EdgeInsets.all(spacing32);

  static const EdgeInsets paddingHorizontalS =
      EdgeInsets.symmetric(horizontal: spacing8);
  static const EdgeInsets paddingHorizontalM =
      EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets paddingHorizontalL =
      EdgeInsets.symmetric(horizontal: spacing24);

  static const EdgeInsets paddingVerticalS =
      EdgeInsets.symmetric(vertical: spacing8);
  static const EdgeInsets paddingVerticalM =
      EdgeInsets.symmetric(vertical: spacing16);
  static const EdgeInsets paddingVerticalL =
      EdgeInsets.symmetric(vertical: spacing24);

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusCircle = 50.0;

  static const BorderRadius borderRadiusXS =
      BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusS =
      BorderRadius.all(Radius.circular(radiusS));
  static const BorderRadius borderRadiusM =
      BorderRadius.all(Radius.circular(radiusM));
  static const BorderRadius borderRadiusL =
      BorderRadius.all(Radius.circular(radiusL));
  static const BorderRadius borderRadiusXL =
      BorderRadius.all(Radius.circular(radiusXL));
  static const BorderRadius borderRadiusXXL =
      BorderRadius.all(Radius.circular(radiusXXL));

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 28.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 40.0;
  static const double iconHuge = 48.0;

  // Avatar Sizes
  static const double avatarS = 32.0;
  static const double avatarM = 40.0;
  static const double avatarL = 48.0;
  static const double avatarXL = 64.0;
  static const double avatarXXL = 80.0;
  static const double avatarHuge = 120.0;

  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;

  // Input Field Heights
  static const double inputHeightS = 36.0;
  static const double inputHeightM = 44.0;
  static const double inputHeightL = 52.0;

  // Card Heights
  static const double cardHeightS = 80.0;
  static const double cardHeightM = 120.0;
  static const double cardHeightL = 160.0;
  static const double cardHeightXL = 200.0;

  // App Bar Height
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;

  // Bottom Navigation Height
  static const double bottomNavHeight = 60.0;

  // Floating Action Button Size
  static const double fabSize = 56.0;
  static const double fabMiniSize = 40.0;

  // ==================== SHADOWS ====================

  static const List<BoxShadow> shadowLight = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  // ==================== ANIMATIONS ====================

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);
  static const Duration animationSlower = Duration(milliseconds: 600);

  // Animation Curves
  static const Curve animationCurveDefault = Curves.easeInOut;
  static const Curve animationCurveEaseIn = Curves.easeIn;
  static const Curve animationCurveEaseOut = Curves.easeOut;
  static const Curve animationCurveBounce = Curves.bounceOut;

  // ==================== OPACITY VALUES ====================

  static const double opacityDisabled = 0.6;
  static const double opacityMedium = 0.7;
  static const double opacityHigh = 0.8;
  static const double opacityOverlay = 0.5;
  static const double opacityModal = 0.8;

  // ==================== ELEVATION VALUES ====================

  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation6 = 6.0;
  static const double elevation8 = 8.0;
  static const double elevation12 = 12.0;
  static const double elevation16 = 16.0;
  static const double elevation24 = 24.0;

  // ==================== SCREEN BREAKPOINTS ====================

  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1280.0;

  // ==================== CAMERA & RECOGNITION CONSTANTS ====================

  // Face Detection Overlay
  static const Color faceOverlayColor = Color(0x4D10B981);
  static const double faceOverlayStrokeWidth = 3.0;
  static const double faceBoundingBoxRadius = 8.0;

  // Camera Preview
  static const Color cameraPreviewBackground = Color(0xFF000000);
  static const Color cameraGuideColor = Color(0xFFFFFFFF);
  static const double cameraGuideOpacity = 0.8;

  // Geofence Visualization
  static const Color geofenceStrokeColor = Color(0xFF3B82F6);
  static const Color geofenceFillColor = Color(0x1A3B82F6);
  static const double geofenceStrokeWidth = 2.0;

  // ==================== STATUS COLORS ====================

  // Attendance Status
  static const Map<String, Color> attendanceStatusColors = {
    'present': presentGreen,
    'absent': absentRed,
    'late': lateOrange,
    'excused': excusedBlue,
  };

  // Network Status
  static const Color networkOnline = successGreen;
  static const Color networkOffline = errorRed;
  static const Color networkPoor = warningOrange;

  // Recognition Status
  static const Color recognitionSuccess = successGreen;
  static const Color recognitionFailed = errorRed;
  static const Color recognitionProcessing = infoBlue;

  // Location Status
  static const Color locationInside = successGreen;
  static const Color locationOutside = errorRed;
  static const Color locationUnknown = warningOrange;

  // ==================== CHART COLORS ====================

  static const List<Color> chartColors = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Orange
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Purple
    Color(0xFF06B6D4), // Cyan
    Color(0xFFEC4899), // Pink
    Color(0xFF84CC16), // Lime
  ];

  // ==================== BRAND COLORS ====================

  // University Brand Colors (customizable per institution)
  static const Color universityPrimary = Color(0xFF1E3A8A);
  static const Color universitySecondary = Color(0xFF10B981);
  static const Color universityAccent = Color(0xFFF59E0B);

  // ==================== ACCESSIBILITY ====================

  // High Contrast Colors
  static const Color highContrastText = Color(0xFF000000);
  static const Color highContrastBackground = Color(0xFFFFFFFF);
  static const Color highContrastBorder = Color(0xFF000000);

  // Focus Colors
  static const Color focusBlue = Color(0xFF2563EB);
  static const Color focusRing = Color(0x4D2563EB);

  // ==================== THEME DATA ====================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
      ),
      fontFamily: primaryFontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        elevation: elevation2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: fontSize20,
          fontWeight: semiBold,
          color: white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: white,
          elevation: elevation2,
          padding: paddingVerticalM,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusM,
          ),
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: fontSize16,
            fontWeight: semiBold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: elevation2,
        color: cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusM,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: borderRadiusS,
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusS,
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusS,
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: paddingM,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
      ),
      fontFamily: primaryFontFamily,
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: white,
        elevation: elevation2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: primaryFontFamily,
          fontSize: fontSize20,
          fontWeight: semiBold,
          color: white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlueLight,
          foregroundColor: white,
          elevation: elevation2,
          padding: paddingVerticalM,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusM,
          ),
          textStyle: const TextStyle(
            fontFamily: primaryFontFamily,
            fontSize: fontSize16,
            fontWeight: semiBold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: elevation2,
        color: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusM,
        ),
      ),
    );
  }
}
