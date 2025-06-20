import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isNetworkAvailable() async {
  //Checking for the connectivity
  List<ConnectivityResult> connection =
      await Connectivity().checkConnectivity();
  //If connected to mobile data or wifi
  if (connection.contains(ConnectivityResult.mobile) ||
      connection.contains(ConnectivityResult.wifi) ||
      connection.contains(ConnectivityResult.ethernet)) {
    //Returning result as true
    return true;
  } else {
    //Returning result as false
    return false;
  }
}
