import 'dart:convert';
import 'dart:io';
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

  Future<void> createEvent(
    Map<String, dynamic> locationData,
    Map<String, dynamic> eventData,
    File? eventThumbnail,
    List<File>? eventImages,
  ) async {
    final locationResponse = await apiService.post('locations/', locationData);

    if (locationResponse.statusCode == 201) {
      final locationBody = jsonDecode(locationResponse.body);
      final locationId = locationBody['id'];

      eventData['location'] = locationId;
      eventData['tags'] = jsonEncode(eventData['tags']);
      final eventResponse = await apiService.postMultipart(
        endpoint: 'events/',
        rawFields: eventData,
        files: eventThumbnail != null ? [eventThumbnail] : [],
        fileField: 'thumbnail',
        requiresAuth: false,
      );

      if (eventResponse.statusCode == 201) {
        if (eventImages != null && eventImages.isNotEmpty) {
          final responseBody = await eventResponse.stream.bytesToString();
          final json = jsonDecode(responseBody);
          final eventId = json['id'];

          await apiService.postMultipart(
            endpoint: 'events/$eventId/upload-images/',
            rawFields: {'event': eventId},
            files: eventImages,
            fileField: 'images',
            requiresAuth: false,
          );
        }
      } else {
        throw Exception(
          'Failed to create event. Status: ${eventResponse.statusCode}. Body: ${await eventResponse.stream.bytesToString()}',
        );
      }
    } else {
      throw Exception(
        'Failed to create location. Status: ${locationResponse.statusCode}',
      );
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await apiService.delete('events/$id/');
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<void> updateEvent(Event updatedEvent) async {
    await apiService.put('events/${updatedEvent.id}', updatedEvent.toJson());
  }

  Future<void> createEventImage(String eventId, File image) async {}

  Future<Participant> createParticipant(String eventId, String username) async {
    try {
      final response = await apiService.post('participants/', {
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
      final response = await apiService.post('participants/', {
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
      final response = await apiService.post('participants/', {
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
