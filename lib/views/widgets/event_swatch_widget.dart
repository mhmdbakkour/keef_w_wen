import 'package:flutter/material.dart';
import 'package:keef_w_wen/data/constants.dart';

import '../../classes/data/event.dart';
import '../pages/event_details_page.dart';

class EventSwatchWidget extends StatelessWidget {
  const EventSwatchWidget({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                event.thumbnailSrc,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      event.title,
                      style: AppTextStyle(context: context).eventCardTitleText,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Status: ${event.openStatus ? "Open" : "Closed"}, Price: ${event.price.floor()}\$, Visibilty: ${event.isPrivate ? "Private" : "Public"}",
                      style: AppTextStyle.eventCardSubText,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
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
              icon: Icon(Icons.info, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
