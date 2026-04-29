import 'package:cherrypick/cherrypick.dart';
import 'package:structured_log/structured_log.dart';

import '../../domain/services/transport_service.dart';

class AcpTransportService implements TransportService, Disposable {
  final _log = getLogger('AcpTransportService');

  String? _host;

  @override
  bool get isConnected => _host != null;

  @override
  Future<void> connect({required String host, required int port}) async {
    _log.info('Connecting to ACP server...', context: {'host': host, 'port': port});
    _host = host;
  }

  @override
  Future<void> disconnect() async {
    _log.info('Disconnecting from ACP server');
    _host = null;
  }

  @override
  Future<Map<String, dynamic>> sendRequest(String method, Map<String, dynamic> params) async {
    _log.info('Sending request', context: {'method': method});
    return {'result': 'stub'};
  }

  @override
  Stream<Map<String, dynamic>> get notifications => const Stream.empty();

  @override
  Future<void> dispose() async {
    await disconnect();
  }
}
