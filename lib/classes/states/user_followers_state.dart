class UserFollowersState {
  final List<String> followers;
  final List<String> following;
  final bool isLoading;
  final String? error;

  UserFollowersState({
    required this.followers,
    required this.following,
    required this.isLoading,
    this.error,
  });

  UserFollowersState copyWith({
    List<String>? followers,
    List<String>? following,
    bool? isLoading,
    String? error,
  }) {
    return UserFollowersState(
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
