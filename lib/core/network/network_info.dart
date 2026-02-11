// 🌐 NETWORK INFO - Checks internet connectivity
// Used to determine if we should make API calls or use cached data

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // TODO: Implement with connectivity_plus package if needed
    // For now, we'll assume we're always connected
    return true;
  }
}