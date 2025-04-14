import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/pages/event_participants_page.dart';

import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../widgets/user_chat_widget.dart';

class EventLobbyPage extends ConsumerStatefulWidget {
  const EventLobbyPage({super.key, required this.event});

  final Event event;

  @override
  ConsumerState<EventLobbyPage> createState() => _EventLobbyPageState();
}

class _EventLobbyPageState extends ConsumerState<EventLobbyPage> {
  final ScrollController feedController = ScrollController();

  late Timer countdownTimer;
  late Duration timeDiff;

  User? loggedUser;

  @override
  void initState() {
    super.initState();
    updateCountdown();
    countdownTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => updateCountdown(),
    );
  }

  void updateCountdown() {
    setState(() {
      timeDiff = widget.event.dateStart.difference(DateTime.now());
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        loggedUser = ref.watch(loggedUserProvider).user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Event Lobby'),
            actions: [
              IconButton(
                icon: const Icon(Icons.people),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              EventParticipantsPage(event: widget.event),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                SizedBox(height: 10),
                _buildEventCountdown(context),
                _buildEventMap(context),
                _buildEventFeed(context),
                _buildEventChat(context),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.exit_to_app),
            onPressed: () {},
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      widget.event.title,
      style: AppTextStyle(context: context).eventDetailsTitle,
    );
  }

  Widget _buildEventMap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
        padding: EdgeInsets.all(6),
        height: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FlutterMap(
            options: MapOptions(
              initialCenter: widget.event.coordinates,
              initialZoom: 13.0,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png?lang=en",
                userAgentPackageName: 'com.example.keef_w_wen',
              ),
              MarkerLayer(
                rotate: true,
                markers: [
                  Marker(
                    alignment: Alignment.topCenter,
                    point: widget.event.coordinates,
                    width: 40.0,
                    height: 40.0,
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventCountdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        children:
            timeDiff.inSeconds > 0
                ? [
                  Text("Countdown", style: AppTextStyle.countdownTitle),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "${timeDiff.inDays}",
                            style: AppTextStyle.countdownNumbers,
                          ),
                          Text("Days", style: AppTextStyle.countdownLabels),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${timeDiff.inHours % 24}",
                            style: AppTextStyle.countdownNumbers,
                          ),
                          Text("Hours", style: AppTextStyle.countdownLabels),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${timeDiff.inMinutes % 60}",
                            style: AppTextStyle.countdownNumbers,
                          ),
                          Text("Minutes", style: AppTextStyle.countdownLabels),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${timeDiff.inSeconds % 60}",
                            style: AppTextStyle.countdownNumbers,
                          ),
                          Text("Seconds", style: AppTextStyle.countdownLabels),
                        ],
                      ),
                    ],
                  ),
                ]
                : [Text("Event has already started")],
      ),
    );
  }

  Widget _buildEventFeed(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text("Event Feed"),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            height: 200,
            child: ListView.builder(
              controller: feedController,
              itemCount: 12,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "This is event information number ${index + 1}",
                    style: AppTextStyle.feedTileTitle,
                  ),
                  trailing: Text("${60 - (index) * 5}s ago"),
                  visualDensity: VisualDensity.compact,
                  dense: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventChat(BuildContext context) {
    return FilledButton.icon(
      icon: Icon(Icons.chat),
      label: Text("Event chat"),
      onPressed: () {
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
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Event Chat",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(8),
                        children: [
                          UserChatWidget(
                            user: loggedUser!,
                            textMessage: "hello",
                          ),
                          UserChatWidget(
                            user: loggedUser!,
                            textMessage: "is this event still on",
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
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
      },
    );
  }
}
