import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kurakaani/core/network/network_info.dart';
part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final _myConnectivity=MyConnectivity.instance;

  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NetworkGainedEvent>((event, emit) => emit(NetworkGainedState()));
    on<NetworkLossEvent>((event, emit) => emit(NetworkLossState()));
    Connectivity().onConnectivityChanged.listen((event) {
      if(event==ConnectivityResult.wifi||event==ConnectivityResult.mobile){
        add(NetworkGainedEvent());
      }
      else{
        add(NetworkLossEvent());
      }
    });
  }

  }


