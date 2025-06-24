import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityViewmodel extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Stream<bool> networkStatusStream() async* {
    final connectivity = Connectivity();

    // Emit initial status
    List<ConnectivityResult> initialResults =
        await connectivity.checkConnectivity();
    yield _isConnected(initialResults);

    // Emit changes
    await for (List<ConnectivityResult> results
        in connectivity.onConnectivityChanged) {
      yield _isConnected(results);
    }
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
  }

  void initializeConnectivity(Function(List<ConnectivityResult>)? onData) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(onData);
  }

  void disposeConnectivity() {
    _connectivitySubscription
        ?.cancel(); // Cancel the subscription to stop listening
    _connectivitySubscription = null;
    // super.dispose();
  }
}
