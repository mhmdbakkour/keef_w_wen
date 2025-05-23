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
  String eventFilter = "Saved Events";

  @override
  Widget build(BuildContext context) {
    final loggedUser = ref.watch(loggedUserProvider).user;
    final events = ref.watch(eventProvider).events;
    final eventInteractions = ref.watch(eventInteractionProvider).interactions;

    List<String> eventIds = [];
    if (eventFilter == "Saved Events") {
      eventIds =
          eventInteractions
              .where(
                (interaction) =>
                    interaction.saved &&
                    interaction.username == loggedUser.username,
              )
              .map((interaction) => interaction.eventId)
              .toList();
    } else if (eventFilter == "Liked Events") {
      eventIds =
          eventInteractions
              .where(
                (interaction) =>
                    interaction.liked &&
                    interaction.username == loggedUser.username,
              )
              .map((interaction) => interaction.eventId)
              .toList();
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
              .where((event) => event.hostOwner == loggedUser.username)
              .map((event) => event.id)
              .toList();
    }

    List<Event> filteredEvents =
        events.where((event) {
          return eventIds.contains(event.id); // Match event ID with the filter
        }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    eventFilter = "Saved Events";
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.bookmark,
                        color:
                            eventFilter == "Saved Events"
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                      ),
                      Text("Saved", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    eventFilter = "Liked Events";
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.favorite,
                        color:
                            eventFilter == "Liked Events"
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                      ),
                      Text("Liked", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    eventFilter = "Hosted Events";
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.event,
                        color:
                            eventFilter == "Hosted Events"
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                      ),
                      Text("Hosted", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    eventFilter = "Owned Events";
                  });
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color:
                            eventFilter == "Owned Events"
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                      ),
                      Text("Owned", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
