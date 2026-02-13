part of 'network_bloc.dart';

abstract class NetworkEvent {}

class _NetworkStatusChanged extends NetworkEvent {
  final bool isConnected;
  _NetworkStatusChanged(this.isConnected);
}
