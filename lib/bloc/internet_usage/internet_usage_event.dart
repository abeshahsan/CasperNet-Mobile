part of 'internet_usage_bloc.dart';

@immutable
abstract class InternetUsageEvent {}

class InitializeInternetUsageEvent extends InternetUsageEvent {}


class RefreshInternetUsageEvent extends InternetUsageEvent {
    RefreshInternetUsageEvent();
}
