import 'package:bloc/bloc.dart';
import 'package:caspernet/routers/base_router/base_router.dart';
import 'package:caspernet/routers/xiaomi_router/xiaomi_router.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'router_event.dart';
part 'router_state.dart';

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  RoomRouter router = XiaomiRouter('admin', '517@sataamab');

  RouterBloc() : super(RouterInitial()) {
    on<SetupRouterEvent>(_onSetupRouter);
    on<RefreshDataEvent>(_onRefreshData);
    on<SendDataEvent>(_onSendData);

    add(SetupRouterEvent());
  }

  void _onSetupRouter(SetupRouterEvent event, Emitter<RouterState> emit) async {
    emit(RouterLoggingIn());
    try {
      await router.login();
      emit(RouterLoggedIn());
    } catch (e) {
      emit(RouterError(e.toString()));
    }
  }

  void _onRefreshData(RefreshDataEvent event, Emitter<RouterState> emit) async {
    emit(RouterDataLoading());
    try {
      String data = await router.getUserInfo();
      emit(RouterDataLoaded(data));
    } catch (e) {
      emit(RouterError(e.toString()));
    }
  }

  void _onSendData(SendDataEvent event, Emitter<RouterState> emit) async {
    emit(RouterDataLoading());
    try {
      await router.setUserInfo(
          event.data['username'].toString(), event.data['password'].toString());
      emit(RouterDataSent(event.data['username'].toString()));
    } catch (e) {
      emit(RouterError(e.toString()));
    }
  }
}
