import '../entities/project_entity.dart';

abstract interface class ProjectRepository {
  Future<void> addProject(ProjectEntity project);
  Future<ProjectEntity?> getProject(String id);
  Future<List<ProjectEntity>> getAllProjects();
  Future<void> removeProject(String id);
  Future<void> clear();
}
