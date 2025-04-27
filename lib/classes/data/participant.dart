class Participant {
  final String id;
  final String username;
  final String eventId;
  final bool? isHost;
  final bool? isOwner;

  Participant({
    required this.id,
    required this.username,
    required this.eventId,
    required this.isHost,
    required this.isOwner,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] ?? '',
      username: json['user'] ?? '',
      eventId: json['event'] ?? '',
      isHost: json['isHost'] ?? false,
      isOwner: json['isOwner'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': username,
      'event': eventId,
      'isHost': isHost,
      'isOwner': isOwner,
    };
  }

  Participant copyWith({
    String? id,
    String? username,
    String? eventId,
    bool? isHost,
    bool? isOwner,
  }) {
    return Participant(
      id: id ?? this.id,
      username: username ?? this.username,
      eventId: eventId ?? this.eventId,
      isHost: isHost ?? this.isHost,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  factory Participant.empty() {
    return Participant(
      id: '',
      username: '',
      eventId: '',
      isHost: false,
      isOwner: false,
    );
  }
}
