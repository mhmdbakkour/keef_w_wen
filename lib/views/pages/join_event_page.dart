import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keef_w_wen/views/pages/view_profile_page.dart';

import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../../data/constants.dart';
import '../widgets/user_avatar_widget.dart';

class JoinEventPage extends ConsumerWidget {
  const JoinEventPage({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<User> users = ref.watch(userProvider).users;

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
                  SizedBox(height: 8),
                  Text(
                    "${DateFormat.yMMMd().format(event.dateStart)} at ${DateFormat.jm().format(event.dateStart)}",
                    style: AppTextStyle.joinEventDate,
                  ),
                  SizedBox(height: 8),
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
                    onPressed: () {},
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
