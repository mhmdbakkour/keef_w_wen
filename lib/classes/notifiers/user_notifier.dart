import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import '../data/user.dart';
import '../states/user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  final UserRepository repository;

  UserNotifier(this.repository) : super(UserState(users: [], isLoading: false));

  void addUser(User user) {
    state = state.copyWith(users: [...state.users, user]);
  }

  bool validateUser(User user) {
    return true;
  }

  void updateUserInfo(String username, User updateUser) {
    state = state.copyWith(
      users: [
        for (final user in state.users)
          if (user.username == username) updateUser else user,
      ],
    );
  }

  void removeUser(String username) {
    state = state.copyWith(
      users: state.users.where((user) => user.username != username).toList(),
    );
  }

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true);

    try {
      List<User> users = await repository.fetchAllUsers();
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
