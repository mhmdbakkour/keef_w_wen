import 'dart:convert';
import 'dart:io';
import '../../services/api_service.dart';
import '../data/event.dart';
import '../data/event_image.dart';
import '../data/event_interaction.dart';
import '../data/location.dart';
import '../data/participant.dart';
import '../notifiers/location_notifier.dart';

class EventRepository {
  final ApiService apiService;

  EventRepository({required this.apiService});

  Future<List<Event>> fetchEvents() async {
    final response = await apiService.get('events/');
    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => Event.fromJson(e)).toList();
  }

  Future<List<EventInteraction>> fetchInteractions() async {
    final response = await apiService.get('event-interactions/');
    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => EventInteraction.fromJson(e)).toList();
  }

  Future<Event> createEvent(
    Map<String, dynamic> locationData,
    Map<String, dynamic> eventData,
    File? eventThumbnail,
    List<File>? eventImages,
    LocationNotifier locationNotifier,
  ) async {
    //Create the location
    final locationResponse = await apiService.post('locations/', locationData);

    //If that was successful...
    if (locationResponse.statusCode == 201) {
      final locationJson = jsonDecode(locationResponse.body);
      locationNotifier.addLocation(Location.fromJson(locationJson));
      final locationId = locationJson['id'];

      //Link location to event data
      eventData['location'] = locationId;
      //Create the event
      final eventResponse = await apiService.postMultipart(
        endpoint: 'events/',
        rawFields: eventData,
        files: eventThumbnail != null ? [eventThumbnail] : [],
        fileField: 'thumbnail',
      );

      //If that was successful...
      if (eventResponse.statusCode == 201) {
        //Get the event ID
        final responseBody = await eventResponse.stream.bytesToString();
        final eventJson = jsonDecode(responseBody);
        final eventId = eventJson['id'];

        Event event = Event.fromJson(eventJson);

        Participant owner = await createOwner(event.id, event.hostOwner);

        event.participants.add(owner);

        if (eventImages != null && eventImages.isNotEmpty) {
          final imagesResponse = await apiService.postMultipart(
            endpoint: 'events/$eventId/upload-images/',
            rawFields: {'event': eventId},
            files: eventImages,
            fileField: 'images',
          );

          final imagesResponseBody =
              await imagesResponse.stream.bytesToString();
          final imagesJson = jsonDecode(imagesResponseBody);

          List<EventImage> images =
              (imagesJson as List).map((e) => EventImage.fromJson(e)).toList();
          event.images.addAll(images);
        }

        return event;
      } else {
        throw Exception(
          'Failed to create event (repository). Status: ${eventResponse.statusCode}',
        );
      }
    } else {
      throw Exception(
        'Failed to create location (repository). Status: ${locationResponse.statusCode}',
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

  Future<Event> updateEvent(
    String eventId,
    Map<String, dynamic> updatedLocationData,
    Map<String, dynamic> updatedEventData,
    File? updatedThumbnail,
    List<File>? newEventImages,
    LocationNotifier locationNotifier,
  ) async {
    // Update the location first
    final locationId = updatedEventData['location'];
    final locationResponse = await apiService.put(
      'locations/$locationId/',
      updatedLocationData,
    );

    if (locationResponse.statusCode == 200) {
      final locationJson = jsonDecode(locationResponse.body);
      locationNotifier.updateLocation(Location.fromJson(locationJson));

      // Prepare updated event data
      updatedEventData['location'] = locationId;

      // Update the event
      final eventResponse = await apiService.patchMultipart(
        endpoint: 'events/$eventId/',
        rawFields: updatedEventData,
        files: updatedThumbnail != null ? [updatedThumbnail] : [],
        fileField: 'thumbnail',
      );

      if (eventResponse.statusCode == 200) {
        final responseBody = await eventResponse.stream.bytesToString();
        final eventJson = jsonDecode(responseBody);
        Event updatedEvent = Event.fromJson(eventJson);

        // Upload new images if available
        if (newEventImages != null && newEventImages.isNotEmpty) {
          final imagesResponse = await apiService.postMultipart(
            endpoint: 'events/$eventId/upload-images/',
            rawFields: {'event': eventId},
            files: newEventImages,
            fileField: 'images',
          );

          final imagesBody = await imagesResponse.stream.bytesToString();
          final imagesJson = jsonDecode(imagesBody);

          List<EventImage> images =
              (imagesJson as List).map((e) => EventImage.fromJson(e)).toList();

          updatedEvent.images.addAll(images);
        }

        return updatedEvent;
      } else {
        throw Exception(
          'Failed to update event. Status: ${eventResponse.statusCode}',
        );
      }
    } else {
      throw Exception(
        'Failed to update location. Status: ${locationResponse.statusCode}',
      );
    }
  }

  Future<bool> toggleStatus(String eventId) async {
    final response = await apiService.patch(
      "events/$eventId/toggle-status/",
      {},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['open_status'];
    } else {
      throw Exception("Failed to toggle status: ${response.body}");
    }
  }

  Future<EventInteraction> likeEvent(String eventId) async {
    try {
      final response = await apiService.post('events/$eventId/interact/', {
        "type": "like",
      });
      final json = jsonDecode(response.body);
      return EventInteraction.fromJson(json);
    } catch (e) {
      throw Exception('Failed to like event: $e');
    }
  }

  Future<EventInteraction> saveEvent(String eventId) async {
    try {
      final response = await apiService.post('events/$eventId/interact/', {
        "type": "save",
      });
      final json = jsonDecode(response.body);
      return EventInteraction.fromJson(json);
    } catch (e) {
      throw Exception('Failed to save event: $e');
    }
  }

  Future<Map<String, bool>> checkEventInteraction(String eventId) async {
    try {
      final response = await apiService.get(
        'events/$eventId/check-interaction/',
      );
      final interactionData = jsonDecode(response.body);

      return {
        'liked': interactionData['liked'] ?? false,
        'saved': interactionData['saved'] ?? false,
      };
    } catch (e) {
      throw Exception('Failed to check event interaction: $e');
    }
  }

  Future<void> createEventImage(String eventId, File image) async {}

  Future<Participant> createParticipant(String eventId, String username) async {
    try {
      final response = await apiService.post('participants/', {
        'event': eventId,
        'user': username,
        'is_host': false,
        'is_owner': false,
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
        'is_host': true,
        'is_owner': false,
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
        'is_host': true,
        'is_owner': true,
      });
      return Participant.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to create owner (backend): $e');
    }
  }
}
