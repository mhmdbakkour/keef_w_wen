import '../data/location.dart';

class LocationState {
  final List<Location> locations;
  final bool isLoading;
  final String? error;

  LocationState({required this.locations, required this.isLoading, this.error});

  LocationState copyWith({
    List<Location>? locations,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      locations: locations ?? this.locations,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
