part of 'internet_usage_bloc.dart';

@immutable
abstract class InternetUsageState extends Equatable {
  final List<UsageData> usageData;

  const InternetUsageState({required this.usageData});

  @override
  List<Object?> get props => [usageData];
}

class InternetUsageInitial extends InternetUsageState {
  const InternetUsageInitial() : super(usageData: const []);
}

class InternetUsageLoading extends InternetUsageState {
  const InternetUsageLoading(List<UsageData> previousUsageData)
      : super(usageData: previousUsageData);
}

class InternetUsageLoaded extends InternetUsageState {
  const InternetUsageLoaded(List<UsageData> usageData)
      : super(usageData: usageData);
}

class InternetUsageError extends InternetUsageState {
  final String message;

  const InternetUsageError(this.message, List<UsageData> previousUsageData)
      : super(usageData: previousUsageData);
}

class InternetUsageTimeout extends InternetUsageState {
  const InternetUsageTimeout(List<UsageData> previousUsageData)
      : super(usageData: previousUsageData);
}
