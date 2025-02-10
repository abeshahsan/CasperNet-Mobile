part of 'internet_usage_bloc.dart';

@immutable
abstract class InternetUsageEvent {}

class LoadInternetUsageEvent extends InternetUsageEvent {}

class RefreshInternetUsageEvent extends InternetUsageEvent {
    RefreshInternetUsageEvent();
}
