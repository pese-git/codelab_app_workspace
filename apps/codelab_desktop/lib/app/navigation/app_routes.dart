sealed class AppRoute {
  const AppRoute();
}

class HomeRoute extends AppRoute {
  const HomeRoute();
}

class SessionRoute extends AppRoute {
  final String sessionId;

  const SessionRoute(this.sessionId);
}

class SettingsRoute extends AppRoute {
  const SettingsRoute();
}
