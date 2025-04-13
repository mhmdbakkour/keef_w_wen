import '../data/user.dart';

class UserState {
  final List<User> users;
  final bool isLoading;
  final String? error;

  UserState({required this.users, required this.isLoading, this.error});

  UserState copyWith({List<User>? users, bool? isLoading, String? error}) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
