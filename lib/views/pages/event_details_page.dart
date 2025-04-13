import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/pages/event_participants_page.dart';
import 'package:keef_w_wen/views/pages/join_event_page.dart';
import 'package:keef_w_wen/views/widgets/rating_widget.dart';

import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';

class EventDetailsPage extends ConsumerWidget {
  const EventDetailsPage({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailColor = Theme.of(context).colorScheme.primary;
    List<User> users = ref.watch(userProvider).users;

    //Event data
    final String title = event.title;
    final String description = event.description;
    final String thumbnailSrc = event.thumbnailSrc;
    final List<String> images = event.images;
    final String hostOwner = event.hostOwner;
    final double distance = event.distance;
    final String location = event.location;
    final bool isPrivate = event.isPrivate;
    final bool hasIdentification = event.needsId;
    final DateTime dateStart = event.dateStart;
    final bool openStatus = event.openStatus;
    final DateTime dateClosed = event.dateClosed;
    final int seats = event.seats;
    final int likes = event.likes;
    final double price = event.price;
    final double rating = event.rating;
    final List<String> tags = event.tags;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyle(context: context).eventDetailsTitle,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 275,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: event.images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            children: [
                              SizedBox(
                                height: 275,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    thumbnailSrc,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black,
                                ),
                                height: 275,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Image.asset(
                                  images[index - 1],
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(description, style: AppTextStyle.eventDetailsDesc),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      users
                          .firstWhere((user) => user.username == hostOwner)
                          .fullname,
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Owner of the event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.portrait, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      location,
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Location of the event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.location_pin, color: detailColor),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      isPrivate ? "Private" : "Public",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Whether the event is public or private",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(
                      isPrivate ? Icons.visibility_off : Icons.visibility,
                      color: detailColor,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      hasIdentification ? "Required" : "Not required",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Attendee identification requirement",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.verified, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      DateFormat('dd/MM/yyyy').format(dateStart),
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Date of when the event starts",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.event_available, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      DateFormat('dd/MM/yyyy').format(dateClosed),
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Date of when the event closes",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.event_note, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      "${distance.floor().toString()}KM away",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Distance from current location to event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.directions_car, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      openStatus ? "Open" : "Closed",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Whether the event is still join-able",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.door_sliding, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      "$seats seats available",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Number of available seats",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.event_seat, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      "${likes} likes received",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Number of likes made by users",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.favorite, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      "${price.floor().toString()} US dollars",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Price of entry",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.attach_money, color: detailColor),
                  ),
                  ListTile(
                    title: Wrap(
                      spacing: 8,
                      children:
                          tags.map((tag) {
                            return ActionChip(
                              label: Text(tag),
                              onPressed: () {},
                            );
                          }).toList(),
                    ),
                    subtitle: Text(
                      "Tags associated with event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.tag),
                  ),
                  ListTile(
                    title: RatingWidget(rating: rating),
                    subtitle: Text(
                      "User rating of event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.rate_review),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EventParticipantsPage(event: event);
                        },
                      ),
                    );
                  },
                  child: Text("View participants"),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Contact")),
                FilledButton(
                  style: ElevatedButton.styleFrom(elevation: 2),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return JoinEventPage(event: event);
                        },
                      ),
                    );
                  },
                  child: Text("Join"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
