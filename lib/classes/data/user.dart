class User {
  final String username;
  String fullname;
  final String email;
  String bio;
  int mobileNumber;
  String? profileSource;
  List<String> followers;
  List<String> following;
  List<String> participatedEvents;
  List<String> likedEvents;
  List<String> savedEvents;

  User({
    required this.username,
    required this.fullname,
    required this.email,
    required this.bio,
    required this.profileSource,
    required this.mobileNumber,
    required this.followers,
    required this.following,
    required this.participatedEvents,
    required this.likedEvents,
    required this.savedEvents,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      profileSource: json['profileSource'] ?? '',
      mobileNumber: json['mobileNumber'] ?? 0,
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      participatedEvents: List<String>.from(json['participatedEvents'] ?? []),
      likedEvents: List<String>.from(json['likedEvents'] ?? []),
      savedEvents: List<String>.from(json['savedEvents'] ?? []),
    );
  }

  factory User.empty() {
    return User(
      username: '',
      fullname: '',
      email: '',
      bio: '',
      profileSource: '',
      mobileNumber: 0,
      followers: [],
      following: [],
      participatedEvents: [],
      likedEvents: [],
      savedEvents: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullname': fullname,
      'email': email,
      'bio': bio,
      'profileSource': profileSource,
      'mobileNumber': mobileNumber,
      'followers': followers,
      'following': following,
      'participatedEvents': participatedEvents,
      'likedEvents': likedEvents,
      'savedEvents': savedEvents,
    };
  }

  User copyWith({
    String? username,
    String? fullname,
    String? email,
    String? bio,
    String? profileSource,
    int? mobileNumber,
    List<String>? followers,
    List<String>? following,
    List<String>? participatedEvents,
    List<String>? likedEvents,
    List<String>? savedEvents,
  }) {
    return User(
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileSource: profileSource ?? this.profileSource,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      participatedEvents: participatedEvents ?? this.participatedEvents,
      likedEvents: likedEvents ?? this.likedEvents,
      savedEvents: savedEvents ?? this.savedEvents,
    );
  }
}
