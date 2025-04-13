class User {
  final String username;
  String fullname;
  final String email;
  String bio;
  int mobileNumber;
  String? profileSource;
  List<String> followers;
  List<String> following;
  List<String> ownedEvents;
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
    required this.ownedEvents,
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
      ownedEvents: List<String>.from(json['ownedEvents'] ?? []),
      likedEvents: List<String>.from(json['likedEvents'] ?? []),
      savedEvents: List<String>.from(json['savedEvents'] ?? []),
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
      'ownedEvents': ownedEvents,
      'likedEvents': likedEvents,
      'savedEvents': savedEvents,
    };
  }
}
