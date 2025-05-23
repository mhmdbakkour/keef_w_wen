import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/event_repository.dart';

import '../data/event_interaction.dart';
import '../states/event_interaction_state.dart';

class EventInteractionNotifier extends StateNotifier<EventInteractionState> {
  final EventRepository repository;

  EventInteractionNotifier(this.repository)
    : super(EventInteractionState(interactions: [], isLoading: false));

  Future<void> fetchInteractions() async {
    state = state.copyWith(isLoading: true);

    try {
      List<EventInteraction> interactions =
          await repository.fetchInteractions();
      state = state.copyWith(interactions: interactions, isLoading: false);
    } catch (e, stack) {
      state = state.copyWith(isLoading: false, error: e.toString());
      throw ArgumentError(stack);
    }
  }

  void likeEvent(String eventId) async {
    try {
      final newInteraction = await repository.likeEvent(eventId);
      final existingIndex = state.interactions.indexWhere(
        (e) => e.eventId == eventId && e.username == newInteraction.username,
      );

      final updatedList = [...state.interactions];

      if (existingIndex != -1) {
        updatedList[existingIndex] = newInteraction;
      } else {
        updatedList.add(newInteraction);
      }

      state = state.copyWith(interactions: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void saveEvent(String eventId) async {
    try {
      final newInteraction = await repository.saveEvent(eventId);
      final existingIndex = state.interactions.indexWhere(
        (e) => e.eventId == eventId && e.username == newInteraction.username,
      );

      final updatedList = [...state.interactions];

      if (existingIndex != -1) {
        updatedList[existingIndex] = newInteraction;
      } else {
        updatedList.add(newInteraction);
      }

      state = state.copyWith(interactions: updatedList);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}
