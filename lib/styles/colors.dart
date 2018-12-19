import 'dart:ui' show Color;

import 'package:flutter/painting.dart';

class MColors extends ColorSwatch<int> {
  const MColors(int primary, Map<int, Color> swatch) : super(primary, swatch);

  static const MColors primary = MColors(
    0xFFF05F3B,
    {
      50: Color(0xFFFACFC4),
      100: Color(0xFFF7AF9D),
      200: Color(0xFFF59982),
      300: Color(0xFFF4866A),
      400: Color(0xFFF27253),
      500: Color(0xFFF05F3B),
      600: Color(0xFFEE4C23),
      700: Color(0xFFE73C12),
      800: Color(0xFFD0350E),
      900: Color(0xFFAC2D0E),
    },
  );

  static const MColors secondary = MColors(
    0xFF0A6284,
    {
      50: Color(0xFFB8CBD3),
      100: Color(0xFF8CB2C0),
      200: Color(0xFF6CA0B5),
      300: Color(0xFF478DA6),
      400: Color(0xFF227190),
      500: Color(0xFF0A6284),
      600: Color(0xFF095876),
      700: Color(0xFF084E69),
      800: Color(0xFF07445C),
      900: Color(0xFF063A4F),
    },
  );

  static const Color white = Color(0xFFFFFFFF);

  static const MColors black = MColors(
    0xFF000000,
    {
      // round(255 * opacity) = Color
      10: Color(0x1A000000),
      15: Color(0x26000000),
      40: Color(0x66000000),
      50: Color(0x80000000),
      75: Color(0xBF000000),
      80: Color(0xCC000000),
      85: Color(0xD9000000),
    },
  );

  static const MColors keppel = MColors(
    0xFF429F9B,
    {
      500: Color(0xFF429F9B),
    },
  );

  static const MColors falu = MColors(
    0xFF89201A,
    {
      500: Color(0xFF89201A),
    },
  );

  static const MColors juan = MColors(
    0xFF595353,
    {
      500: Color(0xFF595353),
    },
  );

  static const MColors celeste = MColors(
    0xFFCFD1CD,
    {
      500: Color(0xFFCFD1CD),
    },
  );

  static const MColors athens = MColors(
    0xFFF4F5F7,
    {
      500: Color(0xFFF4F5F7),
    },
  );

  static const MColors peach = MColors(
    0xFFfaf0f0,
    {
      100: Color(0xFFfaf0f0),
      200: Color(0xFFf0e0e0),
    },
  );

  static const MColors saltpan = MColors(
    0xFFF1F9F1,
    {
      100: Color(0xFFF1F9F1),
      200: Color(0xFFE0F0E0),
    },
  );

  static const MColors whisper = MColors(
    0xFFF0F0F8,
    {
      50: Color(0xFFf9f9fd),
      100: Color(0xFFF0F0F8),
      200: Color(0xFFdfdff0),
    },
  );

  static const Color open = Color(0xFF20A700);
  static const Color success = Color(0xFF20A700);

  static const Color close = Color(0xFFEC152C);
  static const Color error = Color(0xFFEC152C);
}
