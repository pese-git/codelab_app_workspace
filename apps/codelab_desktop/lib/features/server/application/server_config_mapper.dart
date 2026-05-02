import '../../../domain/entities/server.dart';
import '../../../infrastructure/transport/websocket_transport.dart';

/// Маппер Server → AcpServerConfig
///
/// Делегирует преобразование методу Server.toAcpServerConfig().
class ServerConfigMapper {
  static AcpServerConfig toAcpServerConfig(Server server) {
    return server.toAcpServerConfig();
  }
}
