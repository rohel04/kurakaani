import 'package:connectivity_plus/connectivity_plus.dart';

class MyConnectivity{
  MyConnectivity._();
  static final _instance=MyConnectivity._();
  static MyConnectivity get instance=>_instance;
  final _connectivity=Connectivity();
  Future<bool> checkForConnectivityChange() async{
     await _connectivity.onConnectivityChanged.listen((result) async{
      if(result==ConnectivityResult.mobile||result==ConnectivityResult.wifi){
       return Future.value(true);
      }
      else{
        return Future.value(false);
      }
    });
     return Future.value(false);
  }
}