part of 'internet_usage_bloc.dart';

@immutable
abstract class InternetUsageState {
  final List<UsageData> usageData;

  const InternetUsageState({required this.usageData});
}

class InternetUsageEmptyStorage extends InternetUsageState {
  InternetUsageEmptyStorage() : super(usageData: []);
}

// class InternetUsageEmptyFetch extends InternetUsageState {
//   const InternetUsageEmptyFetch(List<UsageData> previousUsageData)
//       : super(usageData: previousUsageData);
// }

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
