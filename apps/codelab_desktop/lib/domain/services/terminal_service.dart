abstract interface class TerminalService {
  Future<String> create({
    required String command,
    List<String>? args,
    Map<String, String>? env,
    String? cwd,
    int? outputByteLimit,
  });
  Future<Map<String, dynamic>> getOutput(String terminalId);
  Future<Map<String, dynamic>> waitForExit(String terminalId);
  Future<void> release(String terminalId);
  Future<bool> kill(String terminalId);
}
