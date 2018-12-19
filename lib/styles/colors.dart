import 'dart:ui' show Color;

import 'package:flutter/painting.dart';

class MColors extends ColorSwatch<int> {

  const MColors._(int primary, Map<int, Color> swatch) : super(primary, swatch);

  static const MColors primary = MColors._(
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

  static const MColors secondary = MColors._(
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

  static const Color clear = Color(0x00FFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black10 = Color(0x1A000000);
  static const Color black15 = Color(0x26000000);
  static const Color black40 = Color(0x66000000);
  static const Color black50 = Color(0x80000000);
  static const Color black75 = Color(0xBF000000);
  static const Color black80 = Color(0xCC000000);
  static const Color black85 = Color(0xD9000000);

  static const MColors black = MColors._(
    0xFF000000,
    {
      // round(255 * opacity) = Color
      10: black10,
      15: black15,
      40: black40,
      50: black50,
      75: black75,
      80: black80,
      85: black85,
    },
  );

  static const MColors keppel = MColors._(
    0xFF429F9B,
    {
      500: Color(0xFF429F9B),
    },
  );

  static const MColors falu = MColors._(
    0xFF89201A,
    {
      500: Color(0xFF89201A),
    },
  );

  static const MColors juan = MColors._(
    0xFF595353,
    {
      500: Color(0xFF595353),
    },
  );

  static const MColors celeste = MColors._(
    0xFFCFD1CD,
    {
      500: Color(0xFFCFD1CD),
    },
  );

  static const MColors athens = MColors._(
    0xFFF4F5F7,
    {
      500: Color(0xFFF4F5F7),
    },
  );

  static const MColors peach = MColors._(
    0xFFfaf0f0,
    {
      100: Color(0xFFfaf0f0),
      200: Color(0xFFf0e0e0),
    },
  );

  static const MColors saltpan = MColors._(
    0xFFF1F9F1,
    {
      100: Color(0xFFF1F9F1),
      200: Color(0xFFE0F0E0),
    },
  );

  static const MColors whisper = MColors._(
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
