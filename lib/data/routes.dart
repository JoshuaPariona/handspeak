abstract class AppRoutes {
  static final AppRoute splash = _AppRoute("/", "splash");
  static final AppRoute welcome = _AppRoute("/welcome", "welcome");
  static final AppRoute signin = _AppRoute("/signin", "signin");
  static final AppRoute login = _AppRoute("/login", "login");
  static final AppDashboardRoutes dashboard = _AppDashboardRoutes();
}

abstract class AppDashboardRoutes {
  String get path;
  String get name;
  AppRoute get translate;
  AppRoute get learn;
  AppRoute get profile;
}

class _AppDashboardRoutes extends AppDashboardRoutes {
  @override
  String get path => "/dashboard";
  @override
  String get name => "dashboard";
  @override
  AppRoute get translate => _AppRoute("$path/translate", "translate");
  @override
  AppRoute get learn => _AppRoute("$path/learn", "learn");
  @override
  AppRoute get profile => _AppRoute("$path/profile", "profile");
}

abstract class AppRoute {
  String get path;
  String get name;
}

class _AppRoute extends AppRoute {
  @override
  String path;
  @override
  String name;
  _AppRoute(this.path, this.name);
}
