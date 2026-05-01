import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../domain/entities/project_entity.dart';
import '../../../../domain/repositories/project_repository.dart';
import '../../../../domain/services/directory_scanner_service.dart';

class OpenProjectUseCase {
  OpenProjectUseCase({
    required DirectoryScannerService directoryScanner,
    required ProjectRepository projectRepository,
  }) : _directoryScanner = directoryScanner,
       _projectRepository = projectRepository;

  final DirectoryScannerService _directoryScanner;
  final ProjectRepository _projectRepository;

  Future<Either<Failure, ProjectEntity>> execute(String directoryPath) async {
    try {
      await _directoryScanner.scanDirectory(
        directoryPath,
        maxDepth: 3,
      );

      final entity = ProjectEntity.fromPath(directoryPath);

      await _projectRepository.addProject(entity);

      return Right(entity);
    } catch (e) {
      return Left(
        FileSystemFailure(
          message: 'Failed to open project: $directoryPath. Error: $e',
          path: directoryPath,
        ),
      );
    }
  }
}
