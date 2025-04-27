class UserFollow {
  final String id;
  final String followerUsername;
  final String followingUsername;
  final DateTime dateFollowed;

  UserFollow({
    required this.id,
    required this.followerUsername,
    required this.followingUsername,
    required this.dateFollowed,
  });

  factory UserFollow.fromJson(Map<String, dynamic> json) {
    return UserFollow(
      id: json['id'],
      followerUsername: json['follower'],
      followingUsername: json['following'],
      dateFollowed: DateTime.parse(json['date_followed']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'follower': followerUsername,
      'following': followingUsername,
      'date_followed': dateFollowed.toIso8601String(),
    };
  }

  UserFollow copyWith({
    String? id,
    String? followerUsername,
    String? followingUsername,
    DateTime? dateFollowed,
  }) {
    return UserFollow(
      id: id ?? this.id,
      followerUsername: followerUsername ?? this.followingUsername,
      followingUsername: followingUsername ?? this.followingUsername,
      dateFollowed: dateFollowed ?? this.dateFollowed,
    );
  }

  factory UserFollow.empty() {
    return UserFollow(
      id: '',
      followerUsername: '',
      followingUsername: '',
      dateFollowed: DateTime.parse('1970-01-01T00:00:00Z'),
    );
  }
}
