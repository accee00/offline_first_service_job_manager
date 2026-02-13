part of 'network_bloc.dart';

enum NetworkStatus { initial, online, offline }

class NetworkState {
  final NetworkStatus status;

  const NetworkState({this.status = NetworkStatus.initial});

  bool get isOnline => status == NetworkStatus.online;
  bool get isOffline => status == NetworkStatus.offline;

  NetworkState copyWith({NetworkStatus? status}) {
    return NetworkState(status: status ?? this.status);
  }
}
