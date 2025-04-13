import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/services/storage_service.dart';
import '../data/event.dart';
import '../states/event_state.dart';
import '../data/participant.dart';

class EventNotifier extends StateNotifier<EventState> {
  final StorageService storageService;

  EventNotifier(this.storageService)
    : super(EventState(events: [], isLoading: false));

  void addEvent(Event event) {
    state = state.copyWith(events: [...state.events, event]);
  }

  bool validateEvent(Event event) {
    try {
      bool hasHost = event.participants.any((p) => p.isHost ?? false);
      if (!hasHost) {
        throw ArgumentError("At least one participant must be a host.");
      }

      List<Participant> owners =
          event.participants.where((p) => p.isOwner ?? false).toList();

      if (owners.isEmpty) {
        throw ArgumentError("The participants must include an owner.");
      }
      if (owners.length > 1) {
        throw ArgumentError("There can only be one owner.");
      }
      if (!(owners.first.isHost ?? false)) {
        throw ArgumentError("The event owner must also be a host.");
      }

      return true;
    } catch (e) {
      print('Validation error: $e');
      return false;
    }
  }

  void updateEventInfo(String eventId, Event updatedEvent) {
    state = state.copyWith(
      events: [
        for (final event in state.events)
          if (event.id == eventId) updatedEvent else event,
      ],
    );
  }

  void removeEvent(String eventId) {
    state = state.copyWith(
      events: state.events.where((event) => event.id != eventId).toList(),
    );
  }

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoading: true);

    try {
      List<Event> events = await storageService.readEventsFromFile();
      state = state.copyWith(events: events, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
