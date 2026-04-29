import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'acp_message.freezed.dart';

const _uuid = Uuid();

typedef JsonRpcId = Object;

@freezed
abstract class JsonRpcError with _$JsonRpcError {
  const factory JsonRpcError({
    required int code,
    required String message,
    Object? data,
  }) = _JsonRpcError;
}

@freezed
sealed class AcpMessage with _$AcpMessage {
  const factory AcpMessage.request({
    required String method,
    required JsonRpcId id,
    Map<String, dynamic>? params,
  }) = AcpRequest;

  const factory AcpMessage.notification({
    required String method,
    Map<String, dynamic>? params,
  }) = AcpNotification;

  const factory AcpMessage.response({
    required JsonRpcId id,
    Object? result,
    JsonRpcError? error,
  }) = AcpResponse;

  static const String jsonrpcVersion = '2.0';

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
        ? JsonRpcError(
            code: errorJson['code'] as int,
            message: errorJson['message'] as String,
            data: errorJson['data'],
          )
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

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{'jsonrpc': jsonrpcVersion};

    return switch (this) {
      AcpRequest(:final method, :final id, :final params) => {
          ...payload,
          'id': id,
          'method': method,
          if (params != null) 'params': params,
        },
      AcpNotification(:final method, :final params) => {
          ...payload,
          'method': method,
          if (params != null) 'params': params,
        },
      AcpResponse(:final id, :final result, :final error) => {
          ...payload,
          'id': id,
          if (error != null)
            'error': {
              'code': error.code,
              'message': error.message,
              'data': error.data,
            }
          else
            'result': result,
        },
    };
  }
}
