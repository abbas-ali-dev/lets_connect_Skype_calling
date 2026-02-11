import 'package:json_annotation/json_annotation.dart';

// Converter to parse timestamps as UTC
class UtcDateTimeConverter implements JsonConverter<DateTime, String> {
  const UtcDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    print('DEBUG UTC CONVERTER: Original timestamp: $json');
    // If the timestamp doesn't end with 'Z', append it to force UTC parsing
    if (!json.endsWith('Z') && !json.contains('+') && !json.contains('Z')) {
      json = json + 'Z';
      print('DEBUG UTC CONVERTER: Added Z, now: $json');
    }
    final parsed = DateTime.parse(json);
    print('DEBUG UTC CONVERTER: Parsed DateTime: $parsed, isUtc: ${parsed.isUtc}');
    return parsed;
  }

  @override
  String toJson(DateTime object) {
    return object.toUtc().toIso8601String();
  }
}
