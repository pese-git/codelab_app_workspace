sealed class AppRoute {
  const AppRoute();
}

class HomeRoute extends AppRoute {
  const HomeRoute();
}

class SessionRoute extends AppRoute {

  const SessionRoute(this.sessionId);
  final String sessionId;
}

class SettingsRoute extends AppRoute {
  const SettingsRoute();
}
