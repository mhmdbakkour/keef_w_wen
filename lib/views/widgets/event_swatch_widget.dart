import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/data/constants.dart';

import '../../classes/data/event.dart';
import '../pages/event_details_page.dart';

class EventSwatchWidget extends ConsumerWidget {
  const EventSwatchWidget({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Event? event = ref.watch(singleEventProvider(eventId));

    if (event == null) {
      return const Center(child: Text("Event not found"));
    }

    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            event.thumbnail.isNotEmpty
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    event.thumbnail,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                )
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.broken_image,
                    size: 30,
                    color: Theme.of(context).colorScheme.error,
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
                      return EventDetailsPage(eventId: event.id);
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
