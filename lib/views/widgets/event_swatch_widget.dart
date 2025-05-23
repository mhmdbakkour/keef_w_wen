import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/data/constants.dart';

import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../pages/edit_event_page.dart';
import '../pages/event_details_page.dart';

class EventSwatchWidget extends ConsumerStatefulWidget {
  const EventSwatchWidget({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventSwatchWidget> createState() => _EventSwatchWidgetState();
}

class _EventSwatchWidgetState extends ConsumerState<EventSwatchWidget> {
  bool hasLiked = false;
  bool hasSaved = false;

  @override
  void initState() {
    super.initState();

    final interaction = ref.read(
      singleEventInteractionProvider(widget.eventId),
    );
    if (interaction != null) {
      hasLiked = interaction.liked;
      hasSaved = interaction.saved;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Event? event = ref.watch(singleEventProvider(widget.eventId));
    final User loggedUser = ref.watch(loggedUserProvider).user;
    final interaction = ref.watch(
      singleEventInteractionProvider(widget.eventId),
    );
    final eventInteractionNotifier = ref.watch(
      eventInteractionProvider.notifier,
    );
    final eventNotifier = ref.read(eventProvider.notifier);

    if (event == null) {
      return const Center(child: Text("Event not found"));
    }

    if (interaction != null) {
      hasLiked = interaction.liked;
      hasSaved = interaction.saved;
    }

    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            event.thumbnail.isNotEmpty
                ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(event.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 50,
                  height: 50,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            event.title,
                            style:
                                AppTextStyle(
                                  context: context,
                                ).eventCardTitleText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (loggedUser.username == event.hostOwner)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Tooltip(
                              message: "You own this event",
                              child: Icon(
                                Icons.workspace_premium,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              event.isPrivate
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 15,
                            ),
                            SizedBox(width: 2),
                            Text(
                              event.isPrivate ? "Private" : "Public",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              event.openStatus
                                  ? Icons.door_front_door_outlined
                                  : Icons.door_front_door,
                              size: 15,
                            ),
                            SizedBox(width: 2),
                            Text(
                              event.openStatus ? "Open" : "Closed",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.attach_money, size: 15),
                            SizedBox(width: 2),
                            Text(
                              event.price > 0
                                  ? "${event.price.floor()}"
                                  : "Free",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              event.needsId
                                  ? Icons.badge
                                  : Icons.badge_outlined,
                              size: 15,
                            ),
                            SizedBox(width: 2),
                            Text(
                              event.needsId ? "Yes" : "No",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              offset: Offset(-10, -5),
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'like':
                    eventInteractionNotifier.likeEvent(widget.eventId);
                    break;
                  case 'save':
                    eventInteractionNotifier.saveEvent(widget.eventId);
                    break;
                  case 'edit':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEventPage(event: event),
                      ),
                    );
                    break;
                  case 'status':
                    eventNotifier.toggleStatus(widget.eventId);
                    break;
                  case 'delete':
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 28,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Delete Event?",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "This action is permanent and irreversible.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Deleting this event will permanently remove it along with all related data.",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  eventNotifier.deleteEvent(widget.eventId);
                                },
                                icon: Icon(Icons.delete_forever),
                                label: Text("Yes, delete it"),
                              ),
                            ],
                          ),
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'like',
                    child: ListTile(
                      leading: Icon(
                        hasLiked ? Icons.favorite : Icons.favorite_outline,
                      ),
                      title: Text('${hasLiked ? "Unlike" : "Like"} event'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'save',
                    child: ListTile(
                      leading: Icon(
                        hasSaved ? Icons.bookmark : Icons.bookmark_outline,
                      ),
                      title: Text('${hasSaved ? "Remove" : "Save"} event'),
                    ),
                  ),
                  if (event.participants
                          .firstWhere(
                            (participant) =>
                                participant.username == loggedUser.username,
                          )
                          .isHost ??
                      false)
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit event'),
                      ),
                    ),
                  if (event.participants
                          .firstWhere(
                            (participant) =>
                                participant.username == loggedUser.username,
                          )
                          .isHost ??
                      false)
                    PopupMenuItem<String>(
                      value: 'status',
                      child: ListTile(
                        leading:
                            event.openStatus
                                ? Icon(Icons.lock)
                                : Icon(Icons.lock_open),
                        title: Text(
                          '${event.openStatus ? "Close" : "Open"} event',
                        ),
                      ),
                    ),
                  if (loggedUser.username == event.hostOwner)
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_forever,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        title: Text(
                          'Delete event',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                ];
              },
            ),
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
