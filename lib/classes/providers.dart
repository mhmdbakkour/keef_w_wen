import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/states/logged_user_state.dart';
import 'package:keef_w_wen/classes/states/user_state.dart';
import '../services/storage_service.dart';
import 'notifiers/event_notifier.dart';
import 'notifiers/logged_user_notifier.dart';
import 'notifiers/user_notifier.dart';
import 'states/event_state.dart';

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

final eventProvider = StateNotifierProvider<EventNotifier, EventState>(
  (ref) => EventNotifier(ref.watch(storageServiceProvider)),
);

final userProvider = StateNotifierProvider<UserNotifier, UserState>(
  (ref) => UserNotifier(ref.watch(storageServiceProvider)),
);

final loggedUserProvider =
    StateNotifierProvider<LoggedUserNotifier, LoggedUserState>(
      (ref) => LoggedUserNotifier(),
    );
