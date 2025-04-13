import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/logged_user_state.dart';
import '../data/user.dart';

class LoggedUserNotifier extends StateNotifier<LoggedUserState> {
  LoggedUserNotifier() : super(LoggedUserState());

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  void clearUser() {
    state = LoggedUserState();
  }
}
