import 'package:injectable/injectable.dart';
import 'ably_service.dart';

/// Global manager for call events across the app
/// Handles subscribing to call channel events (call-accepted, call-rejected, call-ended)
@LazySingleton()
class CallEventManager {
  AblyService? _ablyService;
  final Map<String, bool> _subscribedChannels = {};

  void setAblyService(AblyService service) {
    _ablyService = service;
  }

  void subscribeToCallChannel(String channelName, Function(Map<String, dynamic>) onCallAccepted, 
      Function(Map<String, dynamic>) onCallRejected, Function(Map<String, dynamic>) onCallEnded) {
    
    if (_ablyService == null || _subscribedChannels[channelName] == true) return;

    // Listen for call-accepted event
    _ablyService!.onCallEvent(channelName, 'call-accepted').listen((data) {
      print('DEBUG: Call accepted on channel $channelName: $data');
      onCallAccepted(data);
    });

    // Listen for call-rejected event
    _ablyService!.onCallEvent(channelName, 'call-rejected').listen((data) {
      print('DEBUG: Call rejected on channel $channelName: $data');
      onCallRejected(data);
    });

    // Listen for call-ended event
    _ablyService!.onCallEvent(channelName, 'call-ended').listen((data) {
      print('DEBUG: Call ended on channel $channelName: $data');
      onCallEnded(data);
    });

    _subscribedChannels[channelName] = true;
    print('DEBUG: Subscribed to all events on channel: $channelName');
  }

  void unsubscribeFromCallChannel(String channelName) {
    _subscribedChannels.remove(channelName);
  }
}
