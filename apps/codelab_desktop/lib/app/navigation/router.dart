import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/session_screen.dart';
import '../state/app_controller.dart';

GoRouter buildRouter(CodeLabAppController controller) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: controller,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/session/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId'] ?? '';
          return SessionScreen(sessionId: sessionId);
        },
      ),
    ],
  );
}
