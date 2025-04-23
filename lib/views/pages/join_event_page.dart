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
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      height: 275,
                      child: Image.asset(event.thumbnailSrc, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Event Details Section
                  Text(event.title, style: AppTextStyle.joinEventTitle),
                  Text(
                    "${DateFormat.yMMMd().format(event.dateStart)} at ${DateFormat.jm().format(event.dateStart)}",
                    style: AppTextStyle.joinEventDate,
                  ),
                  Text(event.location, style: AppTextStyle.joinEventLocation),
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
                          event.participants.map((participant) {
                            User user = users.firstWhere(
                              (user) => user.username == participant.username,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: UserAvatarWidget(user: user),
                            );
                          }).toList(),
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
                          title: Text("${event.seats} seats"),
                          leading: Icon(
                            event.seats > 0
                                ? Icons.event_seat
                                : Icons.event_seat_outlined,
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: Text("${event.price.floor().toString()}\$"),
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
                            .addParticipant(event.id, loggedUser.username);

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
