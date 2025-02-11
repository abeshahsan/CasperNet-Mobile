import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:caspernet/accounts.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'internet_usage_event.dart';
part 'internet_usage_state.dart';

class InternetUsageBloc extends Bloc<InternetUsageEvent, InternetUsageState> {
  InternetUsageBloc() : super(InternetUsageInitial()) {
    on<LoadInternetUsageEvent>(_onLoadInternetUsage);
    on<RefreshInternetUsageEvent>(_onRefreshInternetUsage);

    add(LoadInternetUsageEvent());
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
      ).timeout(const Duration(seconds: 10)).catchError((e) {
        emit(InternetUsageTimeout(state.usageData));
      });
      emit(InternetUsageLoaded(usageDataAll));
    } catch (e) {
      emit(InternetUsageError(e.toString(), state.usageData));
    }
  }

  void _onLoadInternetUsage(
      LoadInternetUsageEvent event, Emitter<InternetUsageState> emit) async {
    await _loadOrRefreshInternetUsage(emit);
  }

  void _onRefreshInternetUsage(
      RefreshInternetUsageEvent event, Emitter<InternetUsageState> emit) async {
    await _loadOrRefreshInternetUsage(emit);
  }
}
