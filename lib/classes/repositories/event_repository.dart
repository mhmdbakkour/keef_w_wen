import 'dart:convert';

import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../data/event.dart';

class EventRepository {
  final StorageService storageService;
  final ApiService apiService;

  EventRepository({required this.storageService, required this.apiService});

  Future<List<Event>> fetchLocalEvents() async {
    return storageService.readEventsFromFile();
  }

  Future<List<Event>> fetchRemoteEvents() async {
    final response = await apiService.get('events/');
    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => Event.fromJson(e)).toList();
  }
}
