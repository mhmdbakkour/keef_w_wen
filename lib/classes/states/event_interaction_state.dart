import '../data/event_interaction.dart';

class EventInteractionState {
  final List<EventInteraction> interactions;
  final bool isLoading;
  final String? error;

  EventInteractionState({
    required this.interactions,
    required this.isLoading,
    this.error,
  });

  EventInteractionState copyWith({
    List<EventInteraction>? interactions,
    bool? isLoading,
    String? error,
  }) {
    return EventInteractionState(
      interactions: interactions ?? this.interactions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
