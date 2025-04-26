import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/widgets/event_map_view_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../widgets/user_avatar_widget.dart';
import '../widgets/user_chat_widget.dart';

class EventLobbyPage extends ConsumerStatefulWidget {
  const EventLobbyPage({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventLobbyPage> createState() => _EventLobbyPageState();
}

class _EventLobbyPageState extends ConsumerState<EventLobbyPage> {
  final ScrollController feedController = ScrollController();

  Timer? countdownTimer;
  Duration timeDiff = Duration.zero;
  DateTime? eventStartTime;

  User? loggedUser;

  @override
  void initState() {
    super.initState();
  }

  void startCountdown(DateTime startTime) {
    eventStartTime = startTime;
    countdownTimer?.cancel(); // Cancel any existing timer
    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final diff = startTime.difference(DateTime.now());
      setState(() {
        timeDiff = diff.isNegative ? Duration.zero : diff;
      });
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    feedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(singleEventProvider(widget.eventId));
    loggedUser = ref.watch(loggedUserProvider).user;
    final List<User> users = ref.watch(userProvider).users;

    if (event == null) {
      return const Scaffold(body: Center(child: Text("Event not found")));
    }

    // Start countdown only once
    if (eventStartTime == null) {
      startCountdown(event.dateStart);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Lobby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => _showEventMap(context, event),
          ),
        ],
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () => _showEventChat(context),
        icon: Icon(Icons.chat),
        label: Text("Chat"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildEventCountdown(context, event),
            _buildEventCard(event, users),
            _buildParticipantsScroll(event, users),
            _buildAnnouncements(),
            _buildEventFeed(event, users),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, List<User> users) {
    Duration eventDuration = event.dateClosed.difference(event.dateStart);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          children: [
            Text(
              event.title,
              style: AppTextStyle(context: context).eventLobbyCardTitle,
            ),
            SizedBox(height: 8),
            Text(event.location, style: AppTextStyle.eventLobbyCardLocation),
            SizedBox(height: 8),
            Text(
              "Organized by ${users.firstWhere((user) => user.username == event.hostOwner).fullname}",
              style: AppTextStyle.eventLobbyCardOrganizer,
            ),
            SizedBox(height: 8),
            if (eventDuration.inDays > 0)
              Text(
                "${DateFormat.yMMMd().add_jm().format(event.dateStart)}\n${DateFormat.yMMMd().add_jm().format(event.dateClosed)}",
                style: AppTextStyle.eventLobbyCardDate,
              )
            else
              Text(
                "Today\n${DateFormat.jm().format(event.dateStart)} - ${DateFormat.jm().format(event.dateClosed)}",
                style: AppTextStyle.eventLobbyCardDate,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 10),
            FilledButton(
              child: Text("Leave Event"),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: Text('Leave event'),
                        content: Text(
                          'Are you sure you want to leave ${event.title}?',
                        ),
                        actions: [
                          TextButton(
                            onPressed:
                                () =>
                                    Navigator.of(ctx).pop(true), // return true
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed:
                                () => Navigator.of(
                                  ctx,
                                ).pop(false), // return false
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                );

                if (confirm == false) return;
                if (mounted) {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);

                  try {
                    await ref
                        .read(eventProvider.notifier)
                        .removeParticipant(event.id, loggedUser!.username);

                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('You have left the event.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    navigator.popUntil((r) => r.settings.name == '/main');
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCountdown(BuildContext context, Event event) {
    bool eventOpen = event.openStatus;
    bool eventPending = timeDiff.inSeconds > 0;
    return Card(
      color:
          eventOpen
              ? eventPending
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiaryContainer
              : Theme.of(context).colorScheme.primary,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          children:
              eventOpen
                  ? eventPending
                      ? [
                        Text(
                          "Event begins in:",
                          style: AppTextStyle(context: context).countdownTitle,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (timeDiff.inDays > 0)
                              Column(
                                children: [
                                  Text(
                                    "${timeDiff.inDays}",
                                    style:
                                        AppTextStyle(
                                          context: context,
                                        ).countdownNumbers,
                                  ),
                                  Text(
                                    "Days",
                                    style:
                                        AppTextStyle(
                                          context: context,
                                        ).countdownLabels,
                                  ),
                                ],
                              ),
                            if (timeDiff.inHours > 0)
                              Column(
                                children: [
                                  Text(
                                    "${timeDiff.inHours % 24}",
                                    style:
                                        AppTextStyle(
                                          context: context,
                                        ).countdownNumbers,
                                  ),
                                  Text(
                                    "Hours",
                                    style:
                                        AppTextStyle(
                                          context: context,
                                        ).countdownLabels,
                                  ),
                                ],
                              ),
                            if (timeDiff.inMinutes > 0)
                              Column(
                                children: [
                                  Text(
                                    "${timeDiff.inMinutes % 60}",
                                    style:
                                        AppTextStyle(
                                          context: context,
                                        ).countdownNumbers,
                                  ),
                                  Text(
                                    "Minutes",
                                    style:
                                        AppTextStyle(
                                          context: context,
                                        ).countdownLabels,
                                  ),
                                ],
                              ),
                            Column(
                              children: [
                                Text(
                                  "${timeDiff.inSeconds % 60}",
                                  style:
                                      AppTextStyle(
                                        context: context,
                                      ).countdownNumbers,
                                ),
                                Text(
                                  "Seconds",
                                  style:
                                      AppTextStyle(
                                        context: context,
                                      ).countdownLabels,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]
                      : [
                        Text(
                          "Live Now",
                          style: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ]
                  : [
                    Text(
                      "Event has closed",
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
        ),
      ),
    );
  }

  Widget _buildEventMap(BuildContext context, Event event) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        margin: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: EventMapView(
            title: event.title,
            thumbnailSrc: event.thumbnailSrc,
            coordinates: event.coordinates,
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsScroll(Event event, List<User> users) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Participants (${event.participants.length})",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: SingleChildScrollView(
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
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncements() {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Announcements",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Card(
            color: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Reminder: Bring your own drinks!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventFeed(Event event, List<User> users) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Event Feed",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              User hostUser = users.firstWhere(
                (user) => user.username == event.hostOwner,
              );
              return ListTile(
                leading:
                    hostUser.profileSource != null &&
                            hostUser.profileSource!.isNotEmpty
                        ? CircleAvatar(
                          backgroundImage: AssetImage(hostUser.profileSource!),
                        )
                        : CircleAvatar(child: Text(hostUser.fullname[0])),
                title: Text(event.hostOwner),
                subtitle: Text("Removed ${users[index].fullname}"),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEventMap(BuildContext context, Event event) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.map,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  "Map",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  event.location,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Divider(),
              Expanded(child: _buildEventMap(context, event)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final Uri googleMapUrl = Uri.parse(
                      "https://www.google.com/maps/search/?api=1&query=${event.coordinates.latitude},${event.coordinates.longitude}",
                    );
                    if (await canLaunchUrl(googleMapUrl)) {
                      await launchUrl(
                        googleMapUrl,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text('Could not open Google Maps.')),
                      );
                    }
                  },
                  icon: Icon(Icons.navigation),
                  label: Text("Navigate with Google Maps"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatList(List<String> messages) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        bool isSender = index % 2 == 0;
        return Padding(
          padding: EdgeInsets.only(
            left: index % 2 == 0 ? 80 : 0,
            right: index % 2 == 0 ? 0 : 80,
          ),
          child: UserChatWidget(
            user: loggedUser!,
            textMessage: messages[index],
            isSender: isSender,
          ),
        );
      },
    );
  }

  void _showEventChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder:
          (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.chat_bubble,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    "Chat",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Divider(),
                Expanded(
                  child: _buildChatList([
                    "Hi there!",
                    "What's up my g-wiliker dudadieenos! Do these chat messages wrap?",
                    "How y'all doin'?",
                    "Hi there!",
                    "What's up my g-wiliker dudadieenos! Do these chat messages wrap?",
                    "How y'all doin'?",
                    "Hi there!",
                    "What's up my g-wiliker dudadieenos! Do these chat messages wrap?",
                    "How y'all doin'?",
                    "Hi there!",
                    "What's up my g-wiliker dudadieenos! Do these chat messages wrap?",
                    "How y'all doin'?",
                    "Hi there!",
                    "What's up my g-wiliker dudadieenos! Do these chat messages wrap?",
                    "How y'all doin'?",
                  ]),
                ),
                Divider(height: 1),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "Type a message...",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // send message
                        },
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
