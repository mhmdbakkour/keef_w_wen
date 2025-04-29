import 'dart:convert';

import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../data/event.dart';
import '../data/participant.dart';

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

  // Future<void> saveEventsLocally(List<Event> events) async {
  //   try {
  //     await storageService.saveEvents(events);
  //   } catch (e) {
  //     throw Exception('Failed to save events locally: $e');
  //   }
  // }

  Future<void> createEvent(Event event) async {
    try {
      await apiService.post('/events/', event.toJson());
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await apiService.delete('/events/$id/');
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<void> updateEvent(Event updatedEvent) async {
    await apiService.put('/events/${updatedEvent.id}', updatedEvent.toJson());
  }

  Future<Participant> createParticipant(String eventId, String username) async {
    try {
      final response = await apiService.post('/participants/', {
        'event': eventId,
        'user': username,
        'isHost': false,
        'isOwner': false,
      });
      return Participant.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to create participant: $e');
    }
  }

  Future<Participant> createHost(String eventId, String username) async {
    try {
      final response = await apiService.post('/participants/', {
        'event': eventId,
        'user': username,
        'isHost': true,
        'isOwner': false,
      });
      return Participant.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to create host: $e');
    }
  }

  Future<Participant> createOwner(String eventId, String username) async {
    try {
      final response = await apiService.post('/participants/', {
        'event': eventId,
        'user': username,
        'isHost': true,
        'isOwner': true,
      });
      return Participant.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to create owner (backend): $e');
    }
  }
}
