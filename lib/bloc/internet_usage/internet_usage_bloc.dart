import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:caspernet/accounts.dart';
import 'package:caspernet/iusers/get_usage.dart';
import 'package:caspernet/iusers/usage_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'internet_usage_event.dart';
part 'internet_usage_state.dart';

class InternetUsageBloc extends Bloc<InternetUsageEvent, InternetUsageState> {
  InternetUsageBloc() : super(InternetUsageEmptyStorage()) {
    on<InternetUsageInit>(_onInitializeInternetUsage);
    on<InternetUsageSync>(_onRefreshInternetUsage);

    add(InternetUsageInit());
  }

  Future<void> _onInitializeInternetUsage(
      InternetUsageInit event, Emitter<InternetUsageState> emit) async {
    List<UsageData> storageData = await _loadFromSharedPreferences(emit);

    if (storageData.isNotEmpty) {
      emit(InternetUsageLoaded(storageData));
    } else {
      add(InternetUsageSync());
    }
  }

  void _onRefreshInternetUsage(
      InternetUsageSync event, Emitter<InternetUsageState> emit) async {
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
        throw Exception('No data found');
      }

      await _saveToSharedPreferences(usageDataAll);
      emit(InternetUsageLoaded(usageDataAll));
    } catch (e) {
      debugPrint(e.toString());
      emit(InternetUsageError(e.toString(), state.usageData));
    }
  }

  Future<void> _saveToSharedPreferences(List<UsageData> usageData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonData =
        usageData.map((data) => data.toJson().toString()).toList();
    await prefs.setStringList('usageData', jsonData);
  }

  Future<List<UsageData>> _loadFromSharedPreferences(
      Emitter<InternetUsageState> emit) async {
    try {
      emit(InternetUsageLoading(state.usageData));
      final prefs = await SharedPreferences.getInstance();
      List<String>? jsonData = prefs.getStringList('usageData');

      if (jsonData == null) {
        throw Exception('No data found');
      }

      List<UsageData> usageData =
          jsonData.map((data) => UsageData.fromJson(data)).toList();
      return usageData;
    } catch (e) {
      debugPrint(e.toString());
      emit(InternetUsageError(e.toString(), state.usageData));
      return <UsageData>[];
    }
  }
}
