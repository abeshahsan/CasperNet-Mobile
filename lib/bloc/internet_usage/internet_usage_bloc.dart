import 'dart:async';

import 'package:caspernet/accounts.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'internet_usage_event.dart';
part 'internet_usage_state.dart';

class InternetUsageBloc
    extends HydratedBloc<InternetUsageEvent, InternetUsageState> {
  InternetUsageBloc() : super(InternetUsageEmpty()) {
    on<InitializeInternetUsageEvent>(_onInitializeInternetUsage);
    on<RefreshInternetUsageEvent>(_onRefreshInternetUsage);
  }

  Future<void> _onInitializeInternetUsage(InitializeInternetUsageEvent event,
      Emitter<InternetUsageState> emit) async {
    await _loadOrRefreshInternetUsage(emit);
  }

  Future<void> _loadOrRefreshInternetUsage(
      Emitter<InternetUsageState> emit) async {
    emit(InternetUsageLoading(state.usageData));
    try {
      List<List> accounts = getAccounts();
      List<UsageData> usageDataAll = await Future.wait(
        accounts
            .map((account) => getUsageData(account[0], account[1]))
            .toList(),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        return <UsageData>[];
      });

      if (usageDataAll.isEmpty) {
        emit(InternetUsageTimeout(state.usageData));
        return;
      }
      emit(InternetUsageLoaded(usageDataAll));
    } catch (e) {
      print(e);
      emit(InternetUsageError(e.toString(), state.usageData));
    }
  }

  void _onRefreshInternetUsage(
      RefreshInternetUsageEvent event, Emitter<InternetUsageState> emit) async {
    await _loadOrRefreshInternetUsage(emit);
  }

  @override
  InternetUsageState? fromJson(Map<String, dynamic> json) {
    try {
      List<UsageData> usageData = (json['data'] as List).map((item) {
        return UsageData.fromJson(item);
      }).toList();

      return InternetUsageLoaded(usageData);
    } catch (e) {
      return InternetUsageEmpty();
    }
  }

  @override
  Map<String, dynamic>? toJson(InternetUsageState state) {
    if (state is InternetUsageLoaded) {
      return {'data': state.usageData.map((item) => item.toJson()).toList()};
    }
    return null;
  }
}
