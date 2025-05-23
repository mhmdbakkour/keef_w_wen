import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/views/pages/event_details_page.dart';
import 'package:keef_w_wen/views/pages/event_lobby_page.dart';
import 'package:keef_w_wen/views/widgets/mini_tag_widget.dart';
import 'package:keef_w_wen/views/widgets/rating_widget.dart';
import '../../classes/data/user.dart';
import '../../data/constants.dart';
import '../pages/join_event_page.dart';

class EventCardWidget extends ConsumerWidget {
  const EventCardWidget({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(singleEventProvider(eventId));
    final User loggedUser = ref.watch(loggedUserProvider).user;
    final locations = ref.watch(locationProvider).locations;

    final eventLocation = locations.firstWhere(
      (location) => event!.location == location.id,
    );

    if (event == null) {
      return const Center(child: Text("Event not found"));
    }

    final String title = event.title;
    final String description = event.description;
    final String thumbnail = event.thumbnail;
    final double rating = event.rating;
    final Color iconColor = Theme.of(context).colorScheme.primary;

    bool userAttends =
        event.participants
            .where((user) => user.username == loggedUser.username)
            .toList()
            .isNotEmpty;

    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child:
                thumbnail.isNotEmpty
                    ? Container(
                      constraints: BoxConstraints(minHeight: 225),
                      width: double.infinity,
                      child: Image.network(thumbnail, fit: BoxFit.cover),
                    )
                    : Container(
                      height: 225,
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      width: double.infinity,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
          ),
          SizedBox(height: 10.0),
          Text(title, style: AppTextStyle(context: context).eventCardTitleText),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Text(description, style: AppTextStyle.eventCardDescText),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: event.tags.length,
                    itemBuilder: (context, index) {
                      return MiniTagWidget(
                        label: event.tags[index],
                        selected: false,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.location_pin, size: 17, color: iconColor),
                    Text(
                      eventLocation.name,
                      style: AppTextStyle(context: context).eventCardData,
                    ),
                    VerticalDivider(),
                    Icon(
                      event.seats != 0
                          ? Icons.event_seat
                          : Icons.event_seat_outlined,
                      size: 17,
                      color: iconColor,
                    ),
                    Text(
                      event.seats != -1 ? "${event.seats}" : "∞",
                      style: AppTextStyle(context: context).eventCardData,
                    ),
                    VerticalDivider(),
                    Icon(
                      event.openStatus
                          ? Icons.door_front_door_outlined
                          : Icons.door_front_door,
                      size: 17,
                      color: iconColor,
                    ),
                    Text(
                      event.openStatus ? "Open" : "Closed",
                      style: AppTextStyle(context: context).eventCardData,
                    ),
                    VerticalDivider(),
                  ],
                ),
                //Text(subText, style: AppTextStyle.cardSubText),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingWidget(rating: rating),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EventDetailsPage(eventId: event.id);
                            },
                          ),
                        );
                      },
                      child: Text("Details"),
                    ),
                    userAttends
                        ? TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EventLobbyPage(eventId: event.id);
                                },
                              ),
                            );
                          },
                          child: Text("Enter"),
                        )
                        : TextButton(
                          onPressed:
                              event.openStatus
                                  ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return JoinEventPage(
                                            eventId: event.id,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  : null,
                          child: Text("Join"),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
