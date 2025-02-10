import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:caspernet/accounts.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:meta/meta.dart';

part 'internet_usage_event.dart';
part 'internet_usage_state.dart';

class InternetUsageBloc extends Bloc<InternetUsageEvent, InternetUsageState> {
  InternetUsageBloc() : super(InternetUsageInitial()) {
    on<LoadInternetUsageEvent>(_onLoadInternetUsage);
    on<RefreshInternetUsageEvent>(_onRefreshInternetUsage);
  }

  void _onLoadInternetUsage(
      LoadInternetUsageEvent event, Emitter<InternetUsageState> emit) async {
    emit(InternetUsageLoading());
    try {
      List<List> accounts = getAccounts();
      List<UsageData> usageDataAll = await Future.wait(accounts
          .map((account) => getUsageData(account[0], account[1]))
          .toList());
      emit(InternetUsageLoaded(usageDataAll, accounts));
    } catch (e) {
      emit(InternetUsageError(e.toString()));
    }
  }

  void _onRefreshInternetUsage(
      RefreshInternetUsageEvent event, Emitter<InternetUsageState> emit) async {
    emit(InternetUsageLoading());
    try {
      List<List> accounts = getAccounts();
      List<UsageData> usageDataAll = await Future.wait(
        accounts
            .map((account) => getUsageData(account[0], account[1]))
            .toList(),
      );
      emit(InternetUsageLoaded(usageDataAll, accounts));
    } catch (e) {
      emit(InternetUsageError(e.toString()));
    }
  }
}
