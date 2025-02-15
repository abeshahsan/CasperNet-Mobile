part of 'internet_usage_bloc.dart';

@immutable
abstract class InternetUsageEvent {}

class InternetUsageInit extends InternetUsageEvent {}

class InternetUsageSync extends InternetUsageEvent {}
