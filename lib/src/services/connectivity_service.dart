import 'dart:async';

import 'package:binaryflutterapp/src/enums/connectivity_status.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    // Subscribe to the connectivity Changed Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return ConnectivityStatus.Online;
    } else {
      return ConnectivityStatus.Offline;
    }

//    switch (result) {
//      case ConnectivityResult.mobile:
//        return ConnectivityStatus.Cellular;
//      case ConnectivityResult.wifi:
//        return ConnectivityStatus.WiFi;
//      case ConnectivityResult.none:
//        return ConnectivityStatus.Offline;
//      default:
//        return ConnectivityStatus.Offline;
//    }
  }
}
