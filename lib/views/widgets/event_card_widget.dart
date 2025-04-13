import 'package:flutter/material.dart';
import 'package:keef_w_wen/views/pages/event_details_page.dart';
import 'package:keef_w_wen/views/widgets/rating_widget.dart';
import '../../classes/data/event.dart';
import '../../data/constants.dart';
import '../pages/join_event_page.dart';

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final String title = event.title;
    final String description = event.description;
    final String image = event.thumbnailSrc;
    final double rating = event.rating;
    final Color iconColor = Theme.of(context).colorScheme.primary;

    return Card(
      child: Column(
        children: [
          Hero(
            tag: "event_image${event.id}",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child:
                  image != null
                      ? SizedBox(
                        width: double.infinity,
                        child: Image.asset(image, fit: BoxFit.cover),
                      )
                      : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.black38,
                        child: Center(
                          child: Text(
                            "No image available",
                            style: TextStyle(fontSize: 25),
                          ),
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.location_pin, size: 17, color: iconColor),
                    SizedBox(width: 1),
                    Text(
                      event.location,
                      style: AppTextStyle(context: context).eventCardData,
                    ),
                    VerticalDivider(),
                    Icon(
                      event.seats > 0
                          ? Icons.event_seat
                          : Icons.event_seat_outlined,
                      size: 17,
                      color: iconColor,
                    ),
                    SizedBox(width: 1),
                    Text(
                      "${event.seats}",
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
                    SizedBox(width: 1),
                    Text(
                      event.openStatus ? "Open" : "Closed",
                      style: AppTextStyle(context: context).eventCardData,
                    ),
                    VerticalDivider(),
                    Icon(
                      event.isPrivate ? Icons.visibility_off : Icons.visibility,
                      size: 17,
                      color: iconColor,
                    ),
                    SizedBox(width: 1),
                    Text(
                      event.isPrivate ? "Private" : "Public",
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
                              return EventDetailsPage(event: event);
                            },
                          ),
                        );
                      },
                      child: Text("Details"),
                    ),
                    TextButton(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
