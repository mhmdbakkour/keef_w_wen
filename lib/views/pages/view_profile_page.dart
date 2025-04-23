import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../../data/constants.dart';
import '../widgets/event_card_widget.dart';

class ViewProfilePage extends ConsumerWidget {
  const ViewProfilePage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Event> events = ref.watch(eventProvider).events;

    return Scaffold(
      appBar: AppBar(title: Text("${user.username}'s Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(user),
            _buildStats(user),
            _buildProfileActions(user),
            _buildUserBio(user),
            _buildPublicEvents(user, context, events),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          user.profileSource != null && user.profileSource!.isNotEmpty
              ? CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(user.profileSource!),
              )
              : CircleAvatar(
                radius: 40,
                child: Text(user.fullname[0], style: TextStyle(fontSize: 30)),
              ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullname, style: AppTextStyle.profileFullname),
              Text(user.username, style: AppTextStyle.profileDataDesc),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _infoTile("Events", user.participatedEvents.length.toString()),
          _infoTile("Followers", user.followers.length.toString()),
          _infoTile("Following", user.following.length.toString()),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyle.profileDataNumber),
        Text(title, style: AppTextStyle.profileDataDesc),
      ],
    );
  }

  Widget _buildProfileActions(User user) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add_circle),
            label: Text("Follow"),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.message),
            label: Text("Message"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBio(User user) {
    if (user.bio.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          user.bio,
          textAlign: TextAlign.center,
          style: AppTextStyle.profileBio,
        ),
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget _buildPublicEvents(
    User user,
    BuildContext context,
    List<Event> events,
  ) {
    final publicEvents =
        events
            .where((event) => user.participatedEvents.contains(event.id))
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Public Events",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        if (publicEvents.isEmpty)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 275,
            child: Center(
              child: Text(
                "This user has no public events.",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          )
        else
          Column(
            children:
                publicEvents.map((event) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: EventCardWidget(eventId: event.id),
                  );
                }).toList(),
          ),
      ],
    );
  }
}
