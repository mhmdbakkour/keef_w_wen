import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/notifiers/user_followers_notifier.dart';
import 'package:keef_w_wen/classes/repositories/event_repository.dart';
import 'package:keef_w_wen/classes/repositories/location_repository.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import 'package:keef_w_wen/classes/states/event_interaction_state.dart';
import 'package:keef_w_wen/classes/states/location_state.dart';
import 'package:keef_w_wen/classes/states/user_followers_state.dart';
import '../services/api_service.dart';
import 'data/event_interaction.dart';
import 'notifiers/event_interaction_notifier.dart';
import 'notifiers/location_notifier.dart';
import 'states/logged_user_state.dart';
import 'states/user_state.dart';
import 'data/event.dart';
import 'notifiers/event_notifier.dart';
import 'notifiers/logged_user_notifier.dart';
import 'notifiers/user_notifier.dart';
import 'states/event_state.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  const baseUrl = 'http://10.0.2.2:8000/api';
  return ApiService(baseUrl: baseUrl);
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return EventRepository(apiService: apiService);
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
  final apiService = ref.read(apiServiceProvider);
  return UserRepository(apiService: apiService);
});

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UserNotifier(repository);
});

final loggedUserProvider =
    StateNotifierProvider<LoggedUserNotifier, LoggedUserState>(
      (ref) => LoggedUserNotifier(ref.read(userRepositoryProvider)),
    );

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return LocationRepository(apiService: apiService);
});

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) {
    final repository = ref.read(locationRepositoryProvider);
    return LocationNotifier(repository);
  },
);

final userFollowersProvider = StateNotifierProvider.family<
  UserFollowersNotifier,
  UserFollowersState,
  String
>((ref, username) {
  final repository = ref.read(userRepositoryProvider);
  return UserFollowersNotifier(repository, username);
});

final eventInteractionProvider =
    StateNotifierProvider<EventInteractionNotifier, EventInteractionState>((
      ref,
    ) {
      final repository = ref.read(eventRepositoryProvider);
      return EventInteractionNotifier(repository);
    });

final singleEventInteractionProvider =
    Provider.family<EventInteraction?, String>((ref, id) {
      final loggedUser = ref.watch(loggedUserProvider).user;
      return ref
          .watch(eventInteractionProvider)
          .interactions
          .firstWhere(
            (i) => i.eventId == id && i.username == loggedUser.username,
            orElse: () => EventInteraction.empty(),
          );
    });
