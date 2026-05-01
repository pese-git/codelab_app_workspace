import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';

class InMemoryProjectRepository implements ProjectRepository {
  final _projects = <String, ProjectEntity>{};

  @override
  Future<void> addProject(ProjectEntity project) async {
    _projects[project.id] = project;
  }

  @override
  Future<ProjectEntity?> getProject(String id) async {
    return _projects[id];
  }

  @override
  Future<List<ProjectEntity>> getAllProjects() async {
    return _projects.values.toList();
  }

  @override
  Future<void> removeProject(String id) async {
    _projects.remove(id);
  }

  @override
  Future<void> clear() async {
    _projects.clear();
  }
}
