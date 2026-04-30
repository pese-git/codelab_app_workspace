import 'package:bloc/bloc.dart';
import 'package:structured_log/structured_log.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../infrastructure/services/permission_handler.dart';
import 'permission_event.dart';
import 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc()
      : _permissionHandler = resolve<PermissionHandler>(),
        super(const PermissionState.idle()) {
    _permissionHandler.setUiCallback(_onPermissionRequestFromHandler);

    on<PermissionRequestReceived>(_onRequestReceived);
    on<PermissionOptionSelected>(_onOptionSelected);
    on<PermissionCancelled>(_onCancelled);
  }

  final _log = getLogger('PermissionBloc');
  final PermissionHandler _permissionHandler;

  void _onPermissionRequestFromHandler(PendingPermissionRequest request) {
    _log.debug('PermissionBloc: new request ${request.requestId}');
    add(PermissionEvent.requestReceived(request: request));
  }

  void _onRequestReceived(
    PermissionRequestReceived event,
    Emitter<PermissionState> emit,
  ) {
    emit(PermissionState.awaitingDecision(request: event.request));
  }

  void _onOptionSelected(
    PermissionOptionSelected event,
    Emitter<PermissionState> emit,
  ) {
    _log.debug(
      'Permission ${event.requestId} resolved with ${event.optionId}',
    );
    _permissionHandler.resolve(event.requestId, event.optionId);
    emit(PermissionState.resolved(
      requestId: event.requestId,
      outcome: 'selected:${event.optionId}',
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!isClosed) add(PermissionEvent.cancelled(requestId: event.requestId));
    });
  }

  void _onCancelled(
    PermissionCancelled event,
    Emitter<PermissionState> emit,
  ) {
    _permissionHandler.cancel(event.requestId);
    emit(const PermissionState.idle());
  }

  @override
  Future<void> close() {
    _permissionHandler.setUiCallback((_) {});
    return super.close();
  }
}
