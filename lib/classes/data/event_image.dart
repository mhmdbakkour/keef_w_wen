class EventImage {
  final String id;
  final String event;
  final String image;
  final DateTime dateUploaded;

  EventImage({
    required this.id,
    required this.event,
    required this.image,
    required this.dateUploaded,
  });

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: json['id'] ?? '',
      event: json['event'] ?? '',
      image: json['image'] ?? '',
      dateUploaded: DateTime.parse(
        json['date_uploaded'] ?? '1970-01-01T00:00:00Z',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': event,
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
      event: eventId ?? this.event,
      image: image ?? this.image,
      dateUploaded: dateUploaded ?? this.dateUploaded,
    );
  }

  factory EventImage.empty() {
    return EventImage(
      id: '',
      event: '',
      image: '',
      dateUploaded: DateTime.parse('1970-01-01T00:00:00Z'),
    );
  }
}
