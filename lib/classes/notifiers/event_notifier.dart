import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/event_repository.dart';
import '../data/event.dart';
import '../states/event_state.dart';
import '../data/participant.dart';

class EventNotifier extends StateNotifier<EventState> {
  final EventRepository repository;

  EventNotifier(this.repository)
    : super(EventState(events: [], isLoading: false));

  // Future<void> createEvent(Event event) async {
  //   try {
  //     await repository.createEvent(event);
  //     state = state.copyWith(events: [...state.events, event]);
  //   } catch (e) {
  //     print("Could not create event. Error: $e");
  //   }
  // }

  Future<void> deleteEvent(String eventId) async {
    try {
      await repository.deleteEvent(eventId);
      state = state.copyWith(
        events: state.events.where((event) => event.id != eventId).toList(),
      );
    } catch (e) {
      print("Could not delete event. Error: $e");
    }
  }

  Future<void> updateEvent(Event updatedEvent) async {
    try {
      await repository.updateEvent(updatedEvent);
      state = state.copyWith(
        events: [
          for (final event in state.events)
            if (event.id == updatedEvent.id) updatedEvent else event,
        ],
      );
    } catch (e) {
      print('Could not update event. Error: $e');
    }
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

  Future<void> removeParticipant(String eventId, String username) async {
    final eventIndex = state.events.indexWhere((e) => e.id == eventId);
    if (eventIndex == -1) {
      throw ArgumentError("Event not found");
    }

    final event = state.events[eventIndex];
    final participant = event.participants.firstWhere(
      (p) => p.username == username,
      orElse: () => throw ArgumentError("Participant not found"),
    );

    if (participant.isOwner == true) {
      throw ArgumentError("Cannot remove the event owner.");
    }

    if (participant.isHost == true &&
        event.participants
            .where((x) => x.isHost == true && x.username != username)
            .isEmpty) {
      throw ArgumentError("There must be at least one host remaining.");
    }

    final updated = event.copyWith(
      participants:
          event.participants.where((x) => x.username != username).toList(),
    );
    final newList = [...state.events]..[eventIndex] = updated;
    state = state.copyWith(events: newList);
  }

  Future<void> createParticipant(String eventId, String username) async {
    try {
      final eventIndex = state.events.indexWhere((e) => e.id == eventId);
      if (eventIndex == -1) {
        throw ArgumentError("Event not found");
      }

      final event = state.events[eventIndex];
      final Participant newParticipant = await repository.createParticipant(
        eventId,
        username,
      );

      // Check if the user is already a participant
      if (event.participants.any((user) => user.username == username)) {
        throw ArgumentError('User already joined the event');
      }

      // Check if the event is open to join
      if (!event.openStatus) {
        throw ArgumentError('Event is not open for joining');
      }

      // Add the participant
      final updated = event.copyWith(
        participants: [...event.participants, newParticipant],
      );

      final newList = [...state.events]..[eventIndex] = updated;

      // Update the state with the new event
      state = state.copyWith(events: newList);
    } catch (e) {
      throw Exception('Failed to create participant (frontend): $e');
    }
  }
  //
  // Future<void> toggleLike(String eventId, String username) async {
  //   final index = state.events.indexWhere((e) => e.id == eventId);
  //   if (index == -1) return;
  //
  //   final event = state.events[index];
  //   final hasLiked = event.likedUsers.contains(username);
  //
  //   final updatedEvent = event.copyWith(
  //     likedUsers:
  //         hasLiked
  //             ? event.likedUsers.where((u) => u != username).toList()
  //             : [...event.likedUsers, username],
  //   );
  //
  //   state.events[index] = updatedEvent;
  //   state = state.copyWith(events: state.events);
  // }
  //
  // Future<void> toggleSave(String eventId, String username) async {
  //   final index = state.events.indexWhere((e) => e.id == eventId);
  //   if (index == -1) return;
  //
  //   final event = state.events[index];
  //   final hasLiked = event.savedUsers.contains(username);
  //
  //   final updatedEvent = event.copyWith(
  //     savedUsers:
  //         hasLiked
  //             ? event.savedUsers.where((u) => u != username).toList()
  //             : [...event.savedUsers, username],
  //   );
  //
  //   state.events[index] = updatedEvent;
  //   state = state.copyWith(events: state.events);
  // }

  Future<void> fetchEvents() async {
    state = state.copyWith(isLoading: true);

    try {
      List<Event> events = await repository.fetchRemoteEvents();
      state = state.copyWith(events: events, isLoading: false);
    } catch (e, stack) {
      state = state.copyWith(isLoading: false, error: e.toString());
      throw ArgumentError(stack);
    }
  }
}
