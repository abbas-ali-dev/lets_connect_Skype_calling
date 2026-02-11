/// Agora Configuration
/// Replace with your actual Agora App ID from Agora Console
class AgoraConfig {
  // Agora App ID from console.agora.io (RTC project)
  static const String appId = '4fe3cf99b25b4e86870d6bb7a37efbed';
  
  // For production, implement a token server
  // For testing, you can use null/empty token
  static const bool useTokenServer = false;
  static const String tokenServerUrl = 'https://your-token-server.com/token';
  
  // Channel configuration
  static const int defaultCallTimeout = 30; // seconds
  static const int maxCallDuration = 3600; // seconds (1 hour)
  
  // Video configuration
  static const int defaultVideoWidth = 640;
  static const int defaultVideoHeight = 480;
  static const int defaultVideoFrameRate = 15;
  static const int defaultVideoBitrate = 400; // kbps
  
  // Audio configuration
  static const int defaultAudioBitrate = 48; // kbps
  static const int defaultAudioSampleRate = 48000; // Hz
}
