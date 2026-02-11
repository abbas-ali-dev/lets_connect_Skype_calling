// Ably Configuration
// IMPORTANT: Use the SAME Ably API key that your backend uses
// This allows the frontend to subscribe to Ably events sent by the backend

class AblyConfig {
  // TODO: Replace with your actual Ably API key (same one used by backend)
  // Format: "APP_ID.KEY_ID:KEY_SECRET"
  // Get it from https://ably.com or ask your backend team for the key
  static const String apiKey = 'YOUR_ABLY_API_KEY_HERE';
  
  // Channel naming conventions (must match backend)
  static String userChannel(String userId) => 'user:$userId';
  static String callChannel(String callId) => 'call:$callId';
}
