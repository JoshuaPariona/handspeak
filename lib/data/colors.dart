import 'dart:ui';

abstract class AppColor {
  // palette
  static const int blue = 0xFF63BAD9;
  static const int lightBlue = 0xFFADD9E8;
  static const int darkBlue1 = 0xFF0C6585;
  static const int darkBlue2 = 0xFF044056;
  static const int white = 0xFFFFFFFF;
  static const int black = 0xFF000000;
  static const int lightBlueGray1 = 0xFFBAD1D9;
  static const int lightBlueGray2 = 0xFFA7BEC5;
  static const int lightBlueGray3 = 0xFF86989E;
  static const int gray1 = 0xFFE5E5E5;
  static const int gray2 = 0xFF4D4D4D;
 
  // Theme
  static const Color primary = Color(blue);
  static const Color secondary = Color(white);
  static const Color background = Color(white);
  static const Color surface = Color(white);
  static const Color text = Color(black);
  static const Color onPrimary = Color(white);
  static const Color onSecondary = Color(gray2);
  static const Color onBackground = Color(gray2);
  static const Color onSurface = Color(gray2);
  static const Color accent = Color(darkBlue2);
}
