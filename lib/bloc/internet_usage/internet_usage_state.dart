part of 'internet_usage_bloc.dart';

@immutable
abstract class InternetUsageState {}

class InternetUsageInitial extends InternetUsageState {}

class InternetUsageLoading extends InternetUsageState {}

class InternetUsageLoaded extends InternetUsageState {
  final List<UsageData> usageData;
  final List<List> accounts;

  InternetUsageLoaded(this.usageData, this.accounts);
}

class InternetUsageError extends InternetUsageState {
  final String message;

  InternetUsageError(this.message);
}
