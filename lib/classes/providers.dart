import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/event_repository.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import '../services/api_service.dart';
import 'states/logged_user_state.dart';
import 'states/user_state.dart';
import '../services/storage_service.dart';
import 'data/event.dart';
import 'notifiers/event_notifier.dart';
import 'notifiers/logged_user_notifier.dart';
import 'notifiers/user_notifier.dart';
import 'states/event_state.dart';

final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

final apiServiceProvider = Provider<ApiService>((ref) {
  const baseUrl = 'http://192.168.1.108:8000/api';
  return ApiService(baseUrl: baseUrl);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final storageService = ref.read(storageServiceProvider);
  final apiService = ref.read(apiServiceProvider);
  return EventRepository(
    storageService: storageService,
    apiService: apiService,
  );
});

final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  final repository = ref.read(eventRepositoryProvider);
  return EventNotifier(repository);
});

final singleEventProvider = Provider.family<Event?, String>((ref, id) {
  return ref
      .watch(eventProvider)
      .events
      .firstWhere((e) => e.id == id, orElse: () => Event.empty());
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final storageService = ref.read(storageServiceProvider);
  final apiService = ref.read(apiServiceProvider);
  return UserRepository(storageService: storageService, apiService: apiService);
});

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UserNotifier(repository);
});

final loggedUserProvider =
    StateNotifierProvider<LoggedUserNotifier, LoggedUserState>(
      (ref) => LoggedUserNotifier(),
    );
