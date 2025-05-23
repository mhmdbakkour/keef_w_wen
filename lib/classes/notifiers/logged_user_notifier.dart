import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/user_repository.dart';
import '../states/logged_user_state.dart';
import '../data/user.dart';

class LoggedUserNotifier extends StateNotifier<LoggedUserState> {
  final UserRepository repository;
  LoggedUserNotifier(this.repository)
    : super(LoggedUserState(user: User.empty()));

  Future<void> updateUser(
    String username,
    Map<String, dynamic> userData,
    File? file,
  ) async {
    User updatedUser = await repository.updateUser(username, userData, file);

    state = state.copyWith(user: updatedUser);
  }

  Future<void> deleteUser(String username) async {
    await repository.deleteUser(username);
    clearUser();
  }

  Future<void> followUser(String following) async {
    final currentlyFollowing = state.user.following.contains(following);
    await repository.followUser(state.user.username, following);
    if (currentlyFollowing) {
      state = state.copyWith(
        user: state.user.copyWith(
          following: state.user.following.where((f) => f != following).toList(),
        ),
      );
    } else {
      state = state.copyWith(
        user: state.user.copyWith(
          following: [...state.user.following, following],
        ),
      );
    }
  }

  Future<void> setFollowers() async {
    final following = await repository.getFollowing(state.user.username);
    final followers = await repository.getFollowers(state.user.username);
    state = state.copyWith(
      user: state.user.copyWith(following: following, followers: followers),
    );
  }

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  void clearUser() {
    state = LoggedUserState(user: User.empty());
  }
}
