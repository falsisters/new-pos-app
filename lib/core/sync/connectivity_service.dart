import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service.connectivityStream;
});

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get connectivityStream {
    _controller ??= StreamController<bool>.broadcast(
      onListen: () {
        _subscription = _connectivity.onConnectivityChanged.listen((results) {
          final isConnected = !results.contains(ConnectivityResult.none);
          _controller?.add(isConnected);
        });
      },
      onCancel: () {
        _subscription?.cancel();
      },
    );
    return _controller!.stream;
  }

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  void dispose() {
    _subscription?.cancel();
    _controller?.close();
  }
}
