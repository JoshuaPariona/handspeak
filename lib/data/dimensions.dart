abstract class AppDimensions {
  static final TextSizes text = _TextSizes();
  static final Spacing space = _Spacing();
  static final Breakpoints breakpoints = _Breakpoints();
  static final BorderRadii borderRadius = _BorderRadii();
}

// ---------------------
// Interfaces
// ---------------------

abstract class TextSizes {
  double get extraSmall;
  double get small;
  double get medium;
  double get large;
}

abstract class Spacing {
  double get space1;
  double get space2;
  double get space3;
  double get space4;
  double get space5;
  double get space6;
  double get space7;
  double get space8;
  double get space9;
  double get space10;
}

abstract class Breakpoints {
  int get mobile;
  int get tablet;
  int get desktop;
}

abstract class BorderRadii {
  double get small;
  double get medium;
}

// ---------------------
// Implementations
// ---------------------

class _TextSizes implements TextSizes {
  const _TextSizes();

  @override final double extraSmall = 8.0;
  @override final double small = 12.0;
  @override final double medium = 16.0;
  @override final double large = 18.0;
}

class _Spacing implements Spacing {
  const _Spacing();

  @override final double space1 = 15.0;
  @override final double space2 = 20.0;
  @override final double space3 = 25.0;
  @override final double space4 = 30.0;
  @override final double space5 = 35.0;
  @override final double space6 = 40.0;
  @override final double space7 = 45.0;
  @override final double space8 = 100.0;
  @override final double space9 = 150.0;
  @override final double space10 = 200.0;
}

class _Breakpoints implements Breakpoints {
  const _Breakpoints();

  @override final int mobile = 600;
  @override final int tablet = 1024;
  @override final int desktop = 1440;
}

class _BorderRadii implements BorderRadii {
  const _BorderRadii();

  @override final double small = 10.0;
  @override final double medium = 20.0;
}
