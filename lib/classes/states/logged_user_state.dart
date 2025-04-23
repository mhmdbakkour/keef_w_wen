import '../data/user.dart';

class LoggedUserState {
  final User user;

  LoggedUserState({required this.user});

  LoggedUserState copyWith({User? user}) {
    return LoggedUserState(user: user ?? this.user);
  }
}
