abstract class TransportService {
  Future<void> connect({required String host, required int port});
  Future<void> disconnect();
  bool get isConnected;
  Future<Map<String, dynamic>> sendRequest(String method, Map<String, dynamic> params);
  Stream<Map<String, dynamic>> get notifications;
}
