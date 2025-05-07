import 'package:latlong2/latlong.dart';

class Location {
  final String id;
  final String name;
  final LatLng coordinates;
  final DateTime timestamp;
  final double accuracy;
  final String source;

  Location({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.timestamp,
    required this.accuracy,
    required this.source,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      coordinates: LatLng(json['latitude'] ?? 0, json['longitude'] ?? 0),
      timestamp: DateTime.parse(json['timestamp'] ?? '1970-01-01T00:00:00Z'),
      accuracy: json['accuracy'] ?? 0.0,
      source: json['source'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': coordinates.latitude.toString(),
      'longitude': coordinates.longitude.toString(),
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
      'source': source,
    };
  }

  Location copyWith({
    String? id,
    String? eventId,
    String? name,
    LatLng? coordinates,
    DateTime? timestamp,
    double? accuracy,
    String? source,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      coordinates: coordinates ?? this.coordinates,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      source: source ?? this.source,
    );
  }

  factory Location.empty() {
    return Location(
      id: '',
      name: '',
      coordinates: LatLng(0, 0),
      timestamp: DateTime.parse('1970-01-01T00:00:00Z'),
      accuracy: 0,
      source: '',
    );
  }
}
