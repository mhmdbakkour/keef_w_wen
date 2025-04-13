import '../data/event.dart';

class EventState {
  final List<Event> events;
  final bool isLoading;
  final String? error;

  EventState({required this.events, required this.isLoading, this.error});

  EventState copyWith({List<Event>? events, bool? isLoading, String? error}) {
    return EventState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
