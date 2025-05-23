class EventInteraction {
  final String id;
  final String username;
  final String eventId;
  final bool liked;
  final bool saved;
  final int likesCount;
  final int savesCount;

  EventInteraction({
    required this.id,
    required this.username,
    required this.eventId,
    required this.liked,
    required this.saved,
    required this.likesCount,
    required this.savesCount,
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
      likesCount: json['likes_count'],
      savesCount: json['saves_count'],
    );
  }

  EventInteraction copyWith({
    String? id,
    String? username,
    String? eventId,
    bool? liked,
    bool? saved,
    int? likesCount,
    int? savesCount,
  }) {
    return EventInteraction(
      id: id ?? this.id,
      username: username ?? this.username,
      eventId: eventId ?? this.eventId,
      liked: liked ?? this.liked,
      saved: saved ?? this.saved,
      likesCount: likesCount ?? this.likesCount,
      savesCount: savesCount ?? this.savesCount,
    );
  }

  factory EventInteraction.empty() {
    return EventInteraction(
      id: '',
      username: '',
      eventId: '',
      liked: false,
      saved: false,
      likesCount: 0,
      savesCount: 0,
    );
  }
}
