import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/location.dart';
import '../repositories/location_repository.dart';
import '../states/location_state.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  final LocationRepository repository;

  LocationNotifier(this.repository)
    : super(LocationState(locations: [], isLoading: false));

  Future<void> fetchLocations() async {
    state = state.copyWith(isLoading: true);

    try {
      List<Location> locations = await repository.fetchLocations();
      state = state.copyWith(locations: locations, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addLocation(Location location) async {
    state = state.copyWith(locations: [...state.locations, location]);
  }

  void updateLocation(Location location) {
    final updatedIndex = state.locations.indexWhere(
      (loc) => loc.id == location.id,
    );
    if (updatedIndex != -1) {
      state = state.copyWith(
        locations: [
          ...state.locations.sublist(0, updatedIndex),
          location,
          ...state.locations.sublist(updatedIndex + 1),
        ],
      );
    }
  }
}
