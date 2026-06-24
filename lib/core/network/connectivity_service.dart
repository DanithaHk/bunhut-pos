import 'package:connectivity_plus/connectivity_plus.dart';
class ConnectivityService {
  final Connectivity _conn = Connectivity();

  Stream<bool> get onStatusChange => _conn.onConnectivityChanged
      .map((r) => r != ConnectivityResult.none);

  Future<bool> get isOnline async {
    final r = await _conn.checkConnectivity();
    return r != ConnectivityResult.none;
  }
}