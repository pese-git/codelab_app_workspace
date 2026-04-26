import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/session_screen.dart';
import '../state/app_controller.dart';

/// Контроллер истории навигации поверх GoRouter.
/// Поддерживает back/forward навигацию с сохранением стека маршрутов.
class HistoryController extends ChangeNotifier {
  HistoryController(this._router) {
    _stack.add(_router.routerDelegate.currentConfiguration.uri.toString());
    _router.routerDelegate.addListener(_onRouterChanged);
  }

  final GoRouter _router;
  final List<String> _stack = [];
  int _index = 0;
  bool _isNavigating = false;

  bool get canBack => _index > 0;
  bool get canForward => _index < _stack.length - 1;
  String get currentLocation => _stack.isNotEmpty ? _stack[_index] : '/';
  int get stackLength => _stack.length;

  void _onRouterChanged() {
    if (_isNavigating) return;
    final uri = _router.routerDelegate.currentConfiguration.uri.toString();
    if (_stack.isEmpty || _stack[_index] != uri) {
      if (_index < _stack.length - 1) {
        _stack.removeRange(_index + 1, _stack.length);
      }
      _stack.add(uri);
      _index = _stack.length - 1;
      notifyListeners();
    }
  }

  void back() {
    if (!canBack) return;
    _isNavigating = true;
    _index--;
    _router.go(_stack[_index]);
    _isNavigating = false;
    notifyListeners();
  }

  void forward() {
    if (!canForward) return;
    _isNavigating = true;
    _index++;
    _router.go(_stack[_index]);
    _isNavigating = false;
    notifyListeners();
  }

  void push(String location) {
    if (_index < _stack.length - 1) {
      _stack.removeRange(_index + 1, _stack.length);
    }
    _stack.add(location);
    _index = _stack.length - 1;
    _isNavigating = true;
    _router.go(location);
    _isNavigating = false;
    notifyListeners();
  }

  void replace(String location) {
    if (_stack.isNotEmpty) {
      _stack[_index] = location;
    } else {
      _stack.add(location);
      _index = 0;
    }
    _isNavigating = true;
    _router.go(location);
    _isNavigating = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onRouterChanged);
    super.dispose();
  }
}

/// Синглтон для доступа к history controller из любого места.
HistoryController? _historyControllerInstance;

HistoryController get historyController {
  assert(
    _historyControllerInstance != null,
    'HistoryController not initialized. Call buildRouter first.',
  );
  return _historyControllerInstance!;
}

({GoRouter router, HistoryController history}) buildRouter(
  CodeLabAppController controller,
) {
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: controller,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/session/:sessionId',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId'] ?? '';
          return SessionScreen(sessionId: sessionId);
        },
      ),
    ],
  );
  final history = HistoryController(router);
  _historyControllerInstance = history;
  return (router: router, history: history);
}
