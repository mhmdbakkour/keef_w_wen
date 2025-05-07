import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';

import '../states/user_followers_state.dart';

class UserFollowersNotifier extends StateNotifier<UserFollowersState> {
  final UserRepository repository;
  final String username;

  UserFollowersNotifier(this.repository, this.username)
    : super(UserFollowersState(followers: [], following: [], isLoading: false));

  Future<void> fetchAll() async {
    final followers = await repository.getFollowers(username);
    final following = await repository.getFollowers(username);
    if (followers != state.followers || following != state.following) {
      state = state.copyWith(followers: followers, following: following);
    }
  }

  Future<void> fetchFollowers() async {
    final followers = await repository.getFollowers(username);
    if (followers != state.followers) {
      state = state.copyWith(followers: followers);
    }
  }

  Future<void> fetchFollowing() async {
    final following = await repository.getFollowing(username);
    if (following != state.following) {
      state = state.copyWith(following: following);
    }
  }

  Future<void> refresh() async {
    await fetchFollowers();
    await fetchFollowing();
  }

  void reset() {
    state = state.copyWith(followers: [], following: []);
  }
}
