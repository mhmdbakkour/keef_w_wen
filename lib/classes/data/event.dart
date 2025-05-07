import 'package:keef_w_wen/classes/data/participant.dart';
import 'event_image.dart';

class Event {
  final String id;
  String title;
  String thumbnail;
  List<EventImage> images;
  String description;
  double rating;
  String hostOwner;
  String location;
  bool isPrivate;
  bool needsId;
  final DateTime dateCreated;
  DateTime dateStart;
  DateTime dateClosed;
  DateTime dateEnded;
  int seats;
  double price;
  bool openStatus;
  List<String> tags;
  List<Participant> participants;

  Event({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.images,
    required this.description,
    required this.rating,
    required this.hostOwner,
    required this.location,
    required this.isPrivate,
    required this.needsId,
    required this.dateCreated,
    required this.dateStart,
    required this.dateClosed,
    required this.dateEnded,
    required this.seats,
    required this.price,
    required this.openStatus,
    required this.tags,
    required this.participants,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    List<Participant> participants =
        (json['participants'] as List<dynamic>?)?.map((participant) {
          return Participant.fromJson(participant as Map<String, dynamic>);
        }).toList() ??
        [];

    List<EventImage> images =
        (json['images'] as List<dynamic>?)?.map((image) {
          return EventImage.fromJson(image as Map<String, dynamic>);
        }).toList() ??
        [];

    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: images,
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      hostOwner: json['host_owner'] ?? '',
      location: json['location'] ?? '',
      isPrivate: json['is_private'] ?? false,
      needsId: json['needs_id'] ?? false,
      dateCreated: DateTime.parse(
        json['date_created'] ?? '1970-01-01T00:00:00Z',
      ),
      dateStart: DateTime.parse(json['date_start'] ?? '1970-01-01T00:00:00Z'),
      dateClosed: DateTime.parse(json['date_closed'] ?? '1970-01-01T00:00:00Z'),
      dateEnded: DateTime.parse(json['date_ended'] ?? '1970-01-01T00:00:00Z'),
      seats: (json['seats'] ?? 0).toInt(),
      price: (json['price'] ?? 0.0).toDouble(),
      openStatus: json['open_status'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      participants: participants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'images': images.map((image) => image.toJson()).toList(),
      'description': description,
      'rating': rating.toDouble(),
      'host_owner': hostOwner,
      'location': location,
      'is_private': isPrivate,
      'needs_id': needsId,
      'date_created': dateCreated.toIso8601String(),
      'date_closed': dateClosed.toIso8601String(),
      'date_start': dateStart.toIso8601String(),
      'date_ended': dateEnded.toIso8601String(),
      'seats': seats,
      'price': price,
      'open_status': openStatus,
      'tags': tags,
      'participants':
          participants.map((participant) => participant.toJson()).toList(),
    };
  }

  Event copyWith({
    String? id,
    String? title,
    String? thumbnail,
    List<EventImage>? images,
    String? description,
    double? rating,
    String? hostOwner,
    double? distance,
    String? location,
    bool? isPrivate,
    bool? needsId,
    DateTime? dateCreated,
    DateTime? dateStart,
    DateTime? dateClosed,
    DateTime? dateEnded,
    int? seats,
    List<String>? likedUsers,
    List<String>? savedUsers,
    double? price,
    bool? openStatus,
    List<String>? tags,
    List<Participant>? participants,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      hostOwner: hostOwner ?? this.hostOwner,
      location: location ?? this.location,
      isPrivate: isPrivate ?? this.isPrivate,
      needsId: needsId ?? this.needsId,
      dateCreated: dateCreated ?? this.dateCreated,
      dateStart: dateStart ?? this.dateStart,
      dateClosed: dateClosed ?? this.dateClosed,
      dateEnded: dateEnded ?? this.dateEnded,
      seats: seats ?? this.seats,
      price: price ?? this.price,
      openStatus: openStatus ?? this.openStatus,
      tags: tags ?? this.tags,
      participants: participants ?? this.participants,
    );
  }

  factory Event.empty() {
    return Event(
      id: '',
      title: '',
      thumbnail: '',
      images: [],
      description: '',
      rating: 0.0,
      hostOwner: '',
      location: '',
      isPrivate: false,
      needsId: false,
      dateCreated: DateTime.now(),
      dateStart: DateTime.now(),
      dateClosed: DateTime.now(),
      dateEnded: DateTime.now(),
      seats: 0,
      price: 0.0,
      openStatus: false,
      tags: [],
      participants: [],
    );
  }
}
