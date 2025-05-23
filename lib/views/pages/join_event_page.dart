import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keef_w_wen/views/pages/event_lobby_page.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../../data/constants.dart';
import '../widgets/user_avatar_widget.dart';

class JoinEventPage extends ConsumerWidget {
  const JoinEventPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Event? event = ref.watch(singleEventProvider(eventId));
    User? loggedUser = ref.watch(loggedUserProvider).user;
    List<User> users = ref.watch(userProvider).users;
    final locations = ref.watch(locationProvider).locations;

    final eventLocation = locations.firstWhere(
      (location) => event!.location == location.id,
    );

    if (event == null) {
      return const Scaffold(body: Center(child: Text("Event not found")));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Join Event'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back button
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  event.thumbnail.isNotEmpty
                      ? Container(
                        height: 275,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(event.thumbnail),
                          ),
                        ),
                      )
                      : Container(
                        height: 275,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Theme.of(context).colorScheme.error,
                            size: 50,
                          ),
                        ),
                      ),
                  SizedBox(height: 16),
                  // Event Details Section
                  Text(event.title, style: AppTextStyle.joinEventTitle),
                  Text(
                    "${DateFormat.yMMMd().format(event.dateStart)} at ${DateFormat.jm().format(event.dateStart)}",
                    style: AppTextStyle.joinEventDate,
                  ),
                  Text(
                    eventLocation.name,
                    style: AppTextStyle.joinEventLocation,
                  ),
                  SizedBox(height: 8),
                  Text(
                    event.description,
                    style: AppTextStyle.joinEventDescription,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Participants (${event.participants.length})",
                    style: AppTextStyle.joinEventHeadline,
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          event.participants.isNotEmpty
                              ? event.participants.map((participant) {
                                User user = users.firstWhere(
                                  (user) =>
                                      user.username == participant.username,
                                  orElse: () => User.empty(),
                                );
                                return Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: UserAvatarWidget(user: user),
                                );
                              }).toList()
                              : [],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text(event.isPrivate ? "Private" : "Public"),
                          leading: Icon(
                            event.isPrivate
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: Text(event.openStatus ? "Open" : "Closed"),
                          leading: Icon(Icons.door_sliding),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: Text(
                            event.seats != -1 ? "${event.seats}" : "∞",
                          ),
                          leading: Icon(
                            event.seats > 0
                                ? Icons.event_seat
                                : Icons.event_seat_outlined,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: Text(
                            event.price > 0
                                ? "${event.price.floor().toString()}\$"
                                : "Free",
                          ),
                          leading: Icon(Icons.attach_money),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                  SizedBox(height: 8),
                  FilledButton(
                    style: ElevatedButton.styleFrom(elevation: 4),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);

                      try {
                        await ref
                            .read(eventProvider.notifier)
                            .createParticipant(event.id, loggedUser.username);

                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('You have joined the event.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        navigator.push(
                          MaterialPageRoute(
                            builder:
                                (context) => EventLobbyPage(eventId: event.id),
                          ),
                        );
                      } catch (e) {
                        await showDialog(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                  e is ArgumentError
                                      ? e.message!
                                      : 'Something went wrong.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                        );
                      }
                      ;
                    },
                    child: Text("Join Event"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
