import 'dart:convert';

import '../../services/api_service.dart';
import '../data/location.dart';

class LocationRepository {
  final ApiService apiService;

  LocationRepository({required this.apiService});

  Future<List<Location>> fetchLocations() async {
    final response = await apiService.get('locations/');
    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => Location.fromJson(e)).toList();
  }
}
