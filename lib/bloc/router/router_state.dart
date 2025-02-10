part of 'router_bloc.dart';

@immutable
sealed class RouterState {}

final class RouterInitial extends RouterState {}

final class RouterLoggingIn extends RouterState {}
final class RouterLoggedIn extends RouterState {}

final class RouterDataLoading extends RouterState {}
final class RouterDataLoaded extends RouterState {
  final String data;

  RouterDataLoaded(this.data);
}
final class RouterDataSent extends RouterState {
  final String data;

  RouterDataSent(this.data);
}

final class RouterError extends RouterState {
  final String message;

  RouterError(this.message);
}
