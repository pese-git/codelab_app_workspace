class TerminalHandler {
  Future<String> createTerminal(String command) async {
    return 'terminal_0';
  }

  Future<String> getOutput(String terminalId) async {
    return '';
  }

  Future<int> waitForExit(String terminalId) async {
    return 0;
  }

  Future<void> releaseTerminal(String terminalId) async {}
}
