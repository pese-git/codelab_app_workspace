import 'package:bloc/bloc.dart';
import 'package:structured_log/structured_log.dart';

import '../../../application/dto/session_dto.dart';
import '../../../application/use_cases/initialize_use_case.dart';
import '../../../application/use_cases/create_session_use_case.dart';
import '../../../application/use_cases/load_session_use_case.dart';
import '../../../application/use_cases/list_sessions_use_case.dart';
import '../../../../../domain/services/transport_service.dart';
import 'session_event.dart';
import 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required InitializeUseCase initializeUseCase,
    required CreateSessionUseCase createSessionUseCase,
    required LoadSessionUseCase loadSessionUseCase,
    required ListSessionsUseCase listSessionsUseCase,
    required TransportService transport,
  })  : _initializeUseCase = initializeUseCase,
        _createSessionUseCase = createSessionUseCase,
        _loadSessionUseCase = loadSessionUseCase,
        _listSessionsUseCase = listSessionsUseCase,
        _transport = transport,
        super(const SessionState.initial()) {
    on<SessionInitializeRequested>(_onInitialize);
    on<SessionListRequested>(_onListSessions);
    on<SessionCreateRequested>(_onCreateSession);
    on<SessionLoadRequested>(_onLoadSession);
    on<SessionDisconnectRequested>(_onDisconnect);
  }

  final _log = getLogger('SessionBloc');
  final InitializeUseCase _initializeUseCase;
  final CreateSessionUseCase _createSessionUseCase;
  final LoadSessionUseCase _loadSessionUseCase;
  final ListSessionsUseCase _listSessionsUseCase;
  final TransportService _transport;

  String? _serverHost;
  int? _serverPort;
  InitializeResponseDto? _initResponse;

  Future<void> _onInitialize(
    SessionInitializeRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(const SessionState.loading());
    _serverHost = event.serverHost;
    _serverPort = event.serverPort;

    final result = await _initializeUseCase.execute(
      InitializeRequestDto(
        serverHost: event.serverHost,
        serverPort: event.serverPort,
      ),
    );

    result.fold(
      (failure) {
        _log.error('Initialize failed: ${failure.message}');
        emit(SessionState.error(message: failure.message));
      },
      (response) {
        _initResponse = response;
        emit(SessionState.initialized(initResponse: response));
        add(const SessionEvent.listSessions());
      },
    );
  }

  Future<void> _onListSessions(
    SessionListRequested event,
    Emitter<SessionState> emit,
  ) async {
    final currentInit = _initResponse;
    if (currentInit == null) return;

    emit(const SessionState.loading());

    final result = await _listSessionsUseCase.execute();

    result.fold(
      (failure) => emit(SessionState.error(message: failure.message)),
      (listResponse) => emit(SessionState.sessionListLoaded(
        initResponse: currentInit,
        listResponse: listResponse,
      )),
    );
  }

  Future<void> _onCreateSession(
    SessionCreateRequested event,
    Emitter<SessionState> emit,
  ) async {
    final host = _serverHost;
    final port = _serverPort;
    if (host == null || port == null) return;

    emit(const SessionState.loading());

    final result = await _createSessionUseCase.execute(
      CreateSessionRequestDto(
        serverHost: host,
        serverPort: port,
        cwd: event.cwd,
      ),
    );

    result.fold(
      (failure) => emit(SessionState.error(message: failure.message)),
      (response) => emit(SessionState.active(
        sessionId: response.sessionId,
        serverHost: host,
        serverPort: port,
      )),
    );
  }

  Future<void> _onLoadSession(
    SessionLoadRequested event,
    Emitter<SessionState> emit,
  ) async {
    final host = _serverHost;
    final port = _serverPort;
    if (host == null || port == null) return;

    emit(const SessionState.loading());

    final result = await _loadSessionUseCase.execute(
      LoadSessionRequestDto(
        sessionId: event.sessionId,
        serverHost: host,
        serverPort: port,
      ),
    );

    result.fold(
      (failure) => emit(SessionState.error(message: failure.message)),
      (response) => emit(SessionState.active(
        sessionId: response.sessionId,
        serverHost: host,
        serverPort: port,
      )),
    );
  }

  Future<void> _onDisconnect(
    SessionDisconnectRequested event,
    Emitter<SessionState> emit,
  ) async {
    await _transport.disconnect();
    _initResponse = null;
    emit(const SessionState.initial());
  }

  @override
  Future<void> close() async {
    await _transport.disconnect();
    return super.close();
  }
}
