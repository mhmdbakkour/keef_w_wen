class EventInteraction {
  final String id;
  final String username;
  final String eventId;
  final bool liked;
  final bool saved;
  final DateTime dateInteracted;

  EventInteraction({
    required this.id,
    required this.username,
    required this.eventId,
    required this.liked,
    required this.saved,
    required this.dateInteracted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': username,
      'event': eventId,
      'liked': liked,
      'saved': saved,
    };
  }

  factory EventInteraction.fromJson(Map<String, dynamic> json) {
    return EventInteraction(
      id: json['id'],
      username: json['user'],
      eventId: json['event'],
      liked: json['liked'],
      saved: json['saved'],
      dateInteracted: json['date_interacted'],
    );
  }

  EventInteraction copyWith({
    String? id,
    String? username,
    String? eventId,
    bool? liked,
    bool? saved,
    DateTime? dateInteracted,
  }) {
    return EventInteraction(
      id: id ?? this.id,
      username: username ?? this.username,
      eventId: eventId ?? this.eventId,
      liked: liked ?? this.liked,
      saved: saved ?? this.saved,
      dateInteracted: dateInteracted ?? this.dateInteracted,
    );
  }

  factory EventInteraction.empty() {
    return EventInteraction(
      id: '',
      username: '',
      eventId: '',
      liked: false,
      saved: false,
      dateInteracted: DateTime.parse('1970-01-01T00:00:00Z'),
    );
  }
}
