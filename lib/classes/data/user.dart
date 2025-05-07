import 'dart:ui';
import 'location.dart';

class User {
  final String username;
  String fullname;
  final String email;
  String bio;
  String mobileNumber;
  bool sharingLocation;
  String? profilePicture;
  Color? associatedColor;
  List<String> followers;
  List<String> following;
  Location location;

  User({
    required this.username,
    required this.fullname,
    required this.email,
    required this.bio,
    required this.mobileNumber,
    required this.sharingLocation,
    required this.profilePicture,
    required this.associatedColor,
    required this.followers,
    required this.following,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      sharingLocation: json['sharing_location'] ?? false,
      associatedColor: Color(
        int.parse(json['associated_color'] ?? '0xFFAAAAAA'),
      ),
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      location: Location.fromJson(json['location'] ?? {}),
    );
  }

  factory User.empty() {
    return User(
      username: 'username',
      fullname: '77777777',
      email: 'user@email.com',
      bio: '',
      profilePicture: '',
      mobileNumber: '',
      sharingLocation: false,
      associatedColor: Color(0xFFAAAAAA),
      followers: [],
      following: [],
      location: Location.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'email': email,
      'bio': bio,
      'profile_picture': profilePicture,
      'mobile_number': mobileNumber,
      'sharing_location': sharingLocation,
      'associated_color': associatedColor,
      'followers': followers,
      'following': following,
      'location': location.toJson(),
    };
  }

  User copyWith({
    String? username,
    String? fullname,
    String? email,
    String? bio,
    String? profilePicture,
    String? mobileNumber,
    bool? sharingLocation,
    Color? associatedColor,
    List<String>? followers,
    List<String>? following,
    Location? location,
  }) {
    return User(
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      sharingLocation: sharingLocation ?? this.sharingLocation,
      associatedColor: associatedColor ?? this.associatedColor,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      location: location ?? this.location,
    );
  }
}
