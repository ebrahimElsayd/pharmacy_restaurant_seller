import 'package:flutter/material.dart';

class AppPallete {
  // Text Colors
  static const Color lightGreyForText = Color(0xFF6B7280);
  static const Color blackForText = Color(0xFF111827);
  static const Color lightBlueForText = Color(0xFF3B82F6);
  static const Color darkGreyForText = Color(0xFF4B5563);
  static const Color binkForText = Color(0xFFEF4444);

  // Base Colors
  static const Color lightGrey = Color(0xFF9CA3AF);
  static const Color lightBlack = Color(0xFF374151);
  static const Color lightOrange = Color(0xFFF97316);

  // Primary & Secondary
  static const Color primaryColor = Color(0xFF6366F1); // Modern indigo
  static const Color primaryLight = Color(0xFFE0E7FF);
  static const Color primaryDark = Color(0xFF4338CA);

  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color secondaryLight = Color(0xFFCFFAFE);

  // Status Colors
  static const Color processing = Color(0xFFF59E0B); // Amber
  static const Color processingLight = Color(0xFFFEF3C7);

  static const Color pending = Color(0xFF8B5CF6); // Purple
  static const Color pendingLight = Color(0xFFEDE9FE);

  static const Color shipped = Color(0xFF10B981); // Emerald
  static const Color shippedLight = Color(0xFFD1FAE5);

  static const Color delivered = Color(0xFF059669); // Dark emerald
  static const Color deliveredLight = Color(0xFFECFDF5);

  // Neutral Colors
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9FAFB);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Alert Colors
  static const Color redColor = Color(0xFFEF4444);
  static const Color redLight = Color(0xFFFEE2E2);

  static const Color blueColor = Color(0xFF3B82F6);
  static const Color orangeColor = Color(0xFFF97316);
  static const Color greenColor = Color(0xFF10B981);
  static const Color greyColor = Color(0xFF6B7280);
  static const Color whiteColor = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Primary
    Color(0xFF06B6D4), // Secondary
    Color(0xFF10B981), // Success
    Color(0xFFF59E0B), // Warning
    Color(0xFFEF4444), // Error
    Color(0xFF8B5CF6), // Purple
  ];
}