import 'package:codelab_desktop/domain/entities/acp_message.dart';
import 'package:test/test.dart';

void main() {
  group('AcpMessage', () {
    group('AcpRequest', () {
      test('serializes to JSON with jsonrpc version', () {
        final request = AcpMessage.request(
          method: 'initialize',
          id: '1',
          params: {'protocolVersion': 1},
        );

        final json = request.toJson();

        expect(json['jsonrpc'], '2.0');
        expect(json['method'], 'initialize');
        expect(json['id'], '1');
        expect(json['params'], {'protocolVersion': 1});
      });

      test('generates auto ID', () {
        final request = AcpMessage.requestWithAutoId(
          'session/new',
          params: {'cwd': '/test'},
        );

        expect(request, isA<AcpRequest>());
        expect((request as AcpRequest).id, isNotNull);
      });

      test('omits params when null', () {
        final request = AcpMessage.request(
          method: 'session/list',
          id: '2',
        );

        final json = request.toJson();
        expect(json.containsKey('params'), isFalse);
      });
    });

    group('AcpNotification', () {
      test('serializes without id', () {
        final notification = AcpMessage.notification(
          method: 'session/update',
          params: {'sessionId': 'test'},
        );

        final json = notification.toJson();

        expect(json['jsonrpc'], '2.0');
        expect(json['method'], 'session/update');
        expect(json.containsKey('id'), isFalse);
        expect(json['params'], {'sessionId': 'test'});
      });
    });

    group('AcpResponse', () {
      test('serializes result when no error', () {
        final response = AcpMessage.response(
          id: '1',
          result: {'status': 'ok'},
        );

        final json = response.toJson();

        expect(json['jsonrpc'], '2.0');
        expect(json['id'], '1');
        expect(json['result'], {'status': 'ok'});
        expect(json.containsKey('error'), isFalse);
      });

      test('serializes error when present', () {
        final response = AcpMessage.response(
          id: '1',
          error: const JsonRpcError(code: -32600, message: 'Invalid Request'),
        );

        final json = response.toJson();

        expect(json['error']['code'], -32600);
        expect(json['error']['message'], 'Invalid Request');
        expect(json.containsKey('result'), isFalse);
      });
    });

    group('AcpMessage.fromJson', () {
      test('parses request with method and id', () {
        final json = {
          'jsonrpc': '2.0',
          'method': 'initialize',
          'id': '1',
          'params': {'protocolVersion': 1},
        };

        final message = AcpMessage.fromJson(json);

        expect(message, isA<AcpRequest>());
        expect((message as AcpRequest).method, 'initialize');
      });

      test('parses notification with method but no id', () {
        final json = {
          'jsonrpc': '2.0',
          'method': 'session/update',
          'params': {'sessionId': 'test'},
        };

        final message = AcpMessage.fromJson(json);

        expect(message, isA<AcpNotification>());
        expect((message as AcpNotification).method, 'session/update');
      });

      test('parses response with id and result', () {
        final json = {
          'jsonrpc': '2.0',
          'id': '1',
          'result': {'sessionId': 'test'},
        };

        final message = AcpMessage.fromJson(json);

        expect(message, isA<AcpResponse>());
        final response = message as AcpResponse;
        expect(response.result, {'sessionId': 'test'});
        expect(response.error, isNull);
      });

      test('parses response with error', () {
        final json = {
          'jsonrpc': '2.0',
          'id': '1',
          'error': {'code': -32600, 'message': 'Invalid Request'},
        };

        final message = AcpMessage.fromJson(json);

        expect(message, isA<AcpResponse>());
        final response = message as AcpResponse;
        expect(response.error, isNotNull);
        expect(response.error!.code, -32600);
      });
    });

    group('AcpMessage.errorResponse', () {
      test('creates error response', () {
        final response = AcpMessage.errorResponse(
          id: '1',
          code: -32603,
          message: 'Internal error',
          data: {'detail': 'something went wrong'},
        );

        final json = response.toJson();

        expect(json['id'], '1');
        expect(json['error']['code'], -32603);
        expect(json['error']['message'], 'Internal error');
        expect(json['error']['data'], {'detail': 'something went wrong'});
      });
    });
  });
}
