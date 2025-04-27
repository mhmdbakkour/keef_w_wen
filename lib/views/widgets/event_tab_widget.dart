import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../classes/data/event.dart';
import '../../classes/providers.dart';
import 'event_swatch_widget.dart';

class EventTabWidget extends ConsumerStatefulWidget {
  const EventTabWidget({super.key});

  @override
  ConsumerState<EventTabWidget> createState() => _EventTabState();
}

class _EventTabState extends ConsumerState<EventTabWidget> {
  String eventFilter = "Saved Events"; // Default filter

  @override
  Widget build(BuildContext context) {
    final loggedUser = ref.watch(loggedUserProvider).user;
    final events = ref.watch(eventProvider).events;

    List<String> eventIds = [];
    if (eventFilter == "Saved Events") {
      eventIds =
          events.map((event) => event.id).toList(); //loggedUser.savedEvents;
    } else if (eventFilter == "Liked Events") {
      eventIds =
          events.map((event) => event.id).toList(); //loggedUser.likedEvents;
    } else if (eventFilter == "Hosted Events") {
      eventIds =
          events
              .where(
                (event) => event.participants.any(
                  (p) =>
                      p.username == loggedUser.username && (p.isHost ?? false),
                ),
              )
              .map((event) => event.id)
              .toList();
    } else if (eventFilter == "Owned Events") {
      eventIds =
          events
              .where(
                (event) => event.participants.any(
                  (p) =>
                      p.username == loggedUser.username && (p.isOwner ?? false),
                ),
              )
              .map((event) => event.id)
              .toList();
    }

    List<Event> filteredEvents =
        events.where((event) {
          return eventIds.contains(event.id); // Match event ID with the filter
        }).toList();

    return Column(
      children: [
        // Filter Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              color:
                  eventFilter == "Saved Events"
                      ? Theme.of(context).colorScheme.primary
                      : null,
              onPressed: () {
                setState(() {
                  eventFilter = "Saved Events";
                });
              },
              icon: Icon(Icons.bookmark),
            ),
            IconButton(
              color:
                  eventFilter == "Liked Events"
                      ? Theme.of(context).colorScheme.primary
                      : null,
              onPressed: () {
                setState(() {
                  eventFilter = "Liked Events";
                });
              },
              icon: Icon(Icons.favorite),
            ),
            IconButton(
              color:
                  eventFilter == "Hosted Events"
                      ? Theme.of(context).colorScheme.primary
                      : null,
              onPressed: () {
                setState(() {
                  eventFilter = "Hosted Events";
                });
              },
              icon: Icon(Icons.event),
            ),
            IconButton(
              color:
                  eventFilter == "Owned Events"
                      ? Theme.of(context).colorScheme.primary
                      : null,
              onPressed: () {
                setState(() {
                  eventFilter = "Owned Events";
                });
              },
              icon: Icon(Icons.workspace_premium),
            ),
          ],
        ),
        Expanded(
          child:
              filteredEvents.isEmpty
                  ? Center(
                    child: Text(
                      "No events found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return EventSwatchWidget(eventId: event.id);
                    },
                  ),
        ),
      ],
    );
  }
}
