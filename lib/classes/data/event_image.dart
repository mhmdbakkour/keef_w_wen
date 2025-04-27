class EventImage {
  final String id;
  final String eventId;
  final String image;
  final DateTime dateUploaded;

  EventImage({
    required this.id,
    required this.eventId,
    required this.image,
    required this.dateUploaded,
  });

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: json['id'] ?? '',
      eventId: json['event'] ?? '',
      image: json['image'] ?? '',
      dateUploaded: DateTime.parse(
        json['date_uploaded'] ?? '1970-01-01T00:00:00Z',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': eventId,
      'image': image,
      'date_uploaded': dateUploaded.toIso8601String(),
    };
  }

  EventImage copyWith({
    String? id,
    String? eventId,
    String? image,
    DateTime? dateUploaded,
  }) {
    return EventImage(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      image: image ?? this.image,
      dateUploaded: dateUploaded ?? this.dateUploaded,
    );
  }

  factory EventImage.empty() {
    return EventImage(
      id: '',
      eventId: '',
      image: '',
      dateUploaded: DateTime.parse('1970-01-01T00:00:00Z'),
    );
  }
}
