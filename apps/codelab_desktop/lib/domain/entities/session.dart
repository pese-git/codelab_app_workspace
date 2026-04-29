import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String id,
    required String serverHost,
    required int serverPort,
    required Map<String, dynamic> clientCapabilities,
    required Map<String, dynamic> serverCapabilities,
    required DateTime createdAt,
    @Default(false) bool isAuthenticated,
    String? title,
    String? updatedAt,
    String? cwd,
  }) = _Session;

  const Session._();

  factory Session.create({
    required String serverHost,
    required int serverPort,
    required Map<String, dynamic> clientCapabilities,
    required Map<String, dynamic> serverCapabilities,
    String? sessionId,
    String? cwd,
  }) {
    return Session(
      id: sessionId ?? _generateId(),
      serverHost: serverHost,
      serverPort: serverPort,
      clientCapabilities: clientCapabilities,
      serverCapabilities: serverCapabilities,
      createdAt: DateTime.now().toUtc(),
      cwd: cwd,
    );
  }

  static String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'sess_$timestamp';
  }
}
