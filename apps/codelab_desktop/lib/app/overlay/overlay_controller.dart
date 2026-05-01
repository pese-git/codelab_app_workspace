import 'package:flutter/widgets.dart';

enum AppOverlay {
  settings,
  selectDirectory,
  selectFile,
  selectModel,
  selectProvider,
  selectMcp,
  selectServer,
  editProject,
  forkSession,
  help,
  releaseNotes,
  commandPalette,
  openProject,
}

class OverlayController extends ChangeNotifier {
  AppOverlay? _current;

  AppOverlay? get current => _current;

  void show(AppOverlay overlay) {
    if (_current == overlay) return;
    _current = overlay;
    notifyListeners();
  }

  void close() {
    if (_current == null) return;
    _current = null;
    notifyListeners();
  }
}
