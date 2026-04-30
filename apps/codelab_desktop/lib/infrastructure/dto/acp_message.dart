import 'package:uuid/uuid.dart';

const _uuid = Uuid();

typedef JsonRpcId = Object;

class JsonRpcError {

  factory JsonRpcError.fromJson(Map<String, dynamic> json) {
    return JsonRpcError(
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'],
    );
  }
  const JsonRpcError({
    required this.code,
    required this.message,
    this.data,
  });

  final int code;
  final String message;
  final Object? data;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      if (data != null) 'data': data,
    };
  }
}

sealed class AcpMessage {

  factory AcpMessage.request({
    required String method,
    required JsonRpcId id,
    Map<String, dynamic>? params,
  }) = AcpRequest;

  factory AcpMessage.notification({
    required String method,
    Map<String, dynamic>? params,
  }) = AcpNotification;

  factory AcpMessage.response({
    required JsonRpcId id,
    Object? result,
    JsonRpcError? error,
  }) = AcpResponse;

  factory AcpMessage.requestWithAutoId(
    String method, {
    Map<String, dynamic>? params,
    JsonRpcId? requestId,
  }) {
    return AcpMessage.request(
      method: method,
      id: requestId ?? _uuid.v4().substring(0, 8),
      params: params,
    );
  }

  factory AcpMessage.errorResponse({
    required JsonRpcId id,
    required int code,
    required String message,
    Object? data,
  }) {
    return AcpMessage.response(
      id: id,
      error: JsonRpcError(code: code, message: message, data: data),
    );
  }

  factory AcpMessage.fromJson(Map<String, dynamic> json) {
    final method = json['method'] as String?;
    final id = json['id'];
    final errorJson = json['error'] as Map<String, dynamic>?;
    final error = errorJson != null
        ? JsonRpcError.fromJson(errorJson)
        : null;

    if (method != null && id != null) {
      return AcpMessage.request(
        method: method,
        id: id,
        params: json['params'] as Map<String, dynamic>?,
      );
    }

    if (method != null) {
      return AcpMessage.notification(
        method: method,
        params: json['params'] as Map<String, dynamic>?,
      );
    }

    return AcpMessage.response(
      id: id,
      result: json['result'],
      error: error,
    );
  }
  const AcpMessage();

  static const String jsonrpcVersion = '2.0';

  Map<String, dynamic> toJson();
}

final class AcpRequest extends AcpMessage {
  const AcpRequest({
    required this.method,
    required this.id,
    this.params,
  });

  final String method;
  final JsonRpcId id;
  final Map<String, dynamic>? params;

  @override
  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': AcpMessage.jsonrpcVersion,
      'id': id,
      'method': method,
      if (params != null) 'params': params,
    };
  }
}

final class AcpNotification extends AcpMessage {
  const AcpNotification({
    required this.method,
    this.params,
  });

  final String method;
  final Map<String, dynamic>? params;

  @override
  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': AcpMessage.jsonrpcVersion,
      'method': method,
      if (params != null) 'params': params,
    };
  }
}

final class AcpResponse extends AcpMessage {
  const AcpResponse({
    required this.id,
    this.result,
    this.error,
  });

  final JsonRpcId id;
  final Object? result;
  final JsonRpcError? error;

  @override
  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': AcpMessage.jsonrpcVersion,
      'id': id,
      if (error != null)
        'error': error!.toJson()
      else
        'result': result,
    };
  }
}
