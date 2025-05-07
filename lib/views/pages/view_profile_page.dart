import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../../data/constants.dart';
import '../widgets/event_card_widget.dart';

class ViewProfilePage extends ConsumerStatefulWidget {
  const ViewProfilePage({super.key, required this.user});

  final User user;

  @override
  ConsumerState<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends ConsumerState<ViewProfilePage> {
  bool hasFollowed = false;
  List<String> followers = [];
  List<String> following = [];

  @override
  void initState() {
    ref.read(userFollowersProvider(widget.user.username).notifier).refresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events = ref.watch(eventProvider).events;
    User loggedUser = ref.watch(loggedUserProvider).user;
    final repository = ref.read(userRepositoryProvider);

    followers =
        ref.watch(userFollowersProvider(widget.user.username)).followers;
    following =
        ref.watch(userFollowersProvider(widget.user.username)).following;

    setState(() {
      hasFollowed = followers.contains(loggedUser.username);
    });

    return Scaffold(
      appBar: AppBar(title: Text("${widget.user.username}'s Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(widget.user),
            _buildStats(
              context,
              ref,
              widget.user,
              events
                  .where((event) => event.hostOwner == widget.user.username)
                  .length,
            ),
            _buildProfileActions(widget.user, loggedUser, repository),
            _buildUserBio(widget.user),
            _buildPublicEvents(widget.user, context, events),
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
          user.profilePicture != null && user.profilePicture!.isNotEmpty
              ? CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.profilePicture!),
              )
              : CircleAvatar(
                backgroundColor: user.associatedColor,
                radius: 40,
                child: Text(
                  user.fullname.isNotEmpty
                      ? user.fullname[0]
                      : user.username[0].toUpperCase(),
                  style: TextStyle(fontSize: 30),
                ),
              ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullname.isNotEmpty ? user.fullname : user.username,
                style: AppTextStyle.profileFullname,
              ),
              Text(user.username, style: AppTextStyle.profileDataDesc),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(
    BuildContext context,
    WidgetRef ref,
    User user,
    int eventCount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _infoTile("Events", eventCount),
          _infoTile("Followers", followers.length),
          _infoTile("Following", following.length),
        ],
      ),
    );
  }

  Widget _infoTile(String title, int value) {
    return Column(
      children: [
        Text(value.toString(), style: AppTextStyle.profileDataNumber),
        Text(title, style: AppTextStyle.profileDataDesc),
      ],
    );
  }

  Widget _buildProfileActions(
    User user,
    User loggedUser,
    UserRepository repository,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              setState(() {
                if (hasFollowed) {
                  followers.remove(loggedUser.username);
                } else {
                  followers.add(loggedUser.username);
                }
                hasFollowed = !hasFollowed;
              });

              try {
                await repository.followUser(loggedUser.username, user.username);
              } catch (e) {
                print("Error following/unfollowing: $e");
              }
            },
            icon: Icon(hasFollowed ? Icons.remove_circle : Icons.add_circle),
            label: Text(hasFollowed ? "Unfollow" : "Follow"),
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
    final publicEvents = events.where(
      (event) => event.hostOwner == user.username,
    );

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
