import '../../app/models/workspace_models.dart';

abstract interface class DirectoryScannerService {
  Future<List<WorkspaceNode>> scanDirectory(String path, {int maxDepth});
}
