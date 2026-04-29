abstract interface class FileSystemService {
  Future<String> readTextFile(String path, {int? line, int? limit});
  Future<void> writeTextFile(String path, String content);
  Future<bool> exists(String path);
}
