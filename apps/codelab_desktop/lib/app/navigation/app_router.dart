import 'package:go_router/go_router.dart';

import '../../features/workspace/presentation/screens/home_screen.dart';
import 'navigation_controller.dart';

({GoRouter router, NavigationController navigation}) buildRouter(
  NavigationController existingNavigation,
) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );

  existingNavigation.dispose();
  final navigation = NavigationController(router);

  return (router: router, navigation: navigation);
}
