import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_first_service_job_manager/service/network_service.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final NetworkService _network = NetworkService();

  late final StreamSubscription<bool> _networkSub;

  NetworkBloc() : super(const NetworkState()) {
    _networkSub = _network.connectionStream.listen(
      (isConnected) => add(_NetworkStatusChanged(isConnected)),
    );

    on<_NetworkStatusChanged>(_onStatusChanged);
  }

  Future<void> _onStatusChanged(
    _NetworkStatusChanged event,
    Emitter<NetworkState> emit,
  ) async {
    final newStatus = event.isConnected
        ? NetworkStatus.online
        : NetworkStatus.offline;

    emit(state.copyWith(status: newStatus));
  }

  @override
  Future<void> close() {
    _networkSub.cancel();
    return super.close();
  }
}
