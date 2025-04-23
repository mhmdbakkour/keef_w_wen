import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../classes/data/event.dart';
import '../../classes/data/participant.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../widgets/user_brief_widget.dart';

class EventParticipantsPage extends ConsumerWidget {
  const EventParticipantsPage({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<User> users = ref.watch(userProvider).users;

    return Scaffold(
      appBar: AppBar(title: Text("Participants")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildSection(event.participants, context, users)],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    List<Participant> participants,
    BuildContext context,
    List<User> users,
  ) {
    final hostUsernames =
        participants
            .where((p) => p.isHost == true)
            .map((p) => p.username)
            .toSet();
    final participantUsernames =
        participants
            .where((p) => p.isHost != true)
            .map((p) => p.username)
            .toSet();

    final hosts =
        users.where((user) => hostUsernames.contains(user.username)).toList();
    final notHosts =
        users
            .where((user) => participantUsernames.contains(user.username))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hosts",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          children: hosts.map((user) => UserBriefWidget(user: user)).toList(),
        ),
        Text(
          "Participants",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          children:
              notHosts.map((user) => UserBriefWidget(user: user)).toList(),
        ),
      ],
    );
  }
}
