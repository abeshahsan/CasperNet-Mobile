part of 'router_bloc.dart';

@immutable
sealed class RouterEvent {}

class SetupRouterEvent extends RouterEvent {}

class RefreshDataEvent extends RouterEvent {}

class SendDataEvent extends RouterEvent {
  final Map<String, String> data;

  SendDataEvent(this.data);
}
