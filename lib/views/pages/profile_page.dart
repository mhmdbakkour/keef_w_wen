import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/widgets/user_brief_widget.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../widgets/event_swatch_widget.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        List<Event> events = ref.watch(eventProvider).events;
        List<User> users = ref.watch(userProvider).users;
        User? loggedUser = ref.watch(loggedUserProvider).user;

        if (events.isEmpty) {
          return Center(child: Text("No events available."));
        }
        if (users.isEmpty) {
          return Center(child: Text("No users available."));
        }

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
                  // color: Theme.of(context).colorScheme.surface,
                  // padding: EdgeInsets.all(16),
                  // margin: EdgeInsets.symmetric(horizontal: 16),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      loggedUser != null
                          ? CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              loggedUser.profileSource ?? "",
                            ),
                          )
                          : CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                      SizedBox(height: 10),
                      Text(
                        loggedUser != null ? loggedUser.fullname : "EMPTY!",
                        style: AppTextStyle.profileFullname,
                      ),
                      SizedBox(height: 5),
                      _buildUserBio(
                        loggedUser != null
                            ? loggedUser.bio
                            : "Bio goes here...",
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _infoTile(
                            "Events",
                            loggedUser != null
                                ? loggedUser.ownedEvents.length.toString()
                                : "0",
                          ),
                          _infoTile(
                            "Followers",
                            loggedUser != null
                                ? loggedUser.followers.length.toString()
                                : "0",
                          ),
                          _infoTile(
                            "Following",
                            loggedUser != null
                                ? loggedUser.following.length.toString()
                                : "0",
                          ),
                        ],
                      ),
                      _buildProfileActions(),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.event), text: "Events"),
                    Tab(icon: Icon(Icons.add_circle), text: "Followers"),
                    Tab(icon: Icon(Icons.directions_walk), text: "Following"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _userEvents(
                        loggedUser != null
                            ? events
                                .where(
                                  (event) =>
                                      loggedUser.ownedEvents.contains(event.id),
                                )
                                .toList()
                            : [],

                        // events
                      ),
                      _userFollowers(loggedUser!, users),
                      _userFollowing(loggedUser, users),
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

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(value, style: AppTextStyle.profileDataNumber),
        Text(title, style: AppTextStyle.profileDataDesc),
      ],
    );
  }

  Widget _buildProfileActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.edit),
            label: Text("Edit Profile"),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.share),
            label: Text("Share Profile"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBio(String bio) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        bio,
        textAlign: TextAlign.center,
        style: AppTextStyle.profileBio,
      ),
    );
  }

  Widget _userEvents(List<Event> events) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: EventSwatchWidget(event: events[index]),
        );
      },
    );
  }

  Widget _userFollowers(User loggedUser, List<User> users) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: loggedUser.followers.length,
      itemBuilder: (context, index) {
        User user = users.firstWhere(
          (u) => u.username == loggedUser.followers[index],
        ); // This may be a problem if the user was not found!!!
        return UserBriefWidget(user: user);
      },
    );
  }

  Widget _userFollowing(User loggedUser, List<User> users) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: loggedUser.following.length,
      itemBuilder: (context, index) {
        User user = users.firstWhere(
          (u) => u.username == loggedUser.following[index],
        ); // This may be a problem if the user was not found!!!
        return UserBriefWidget(user: user);
      },
    );
  }
}
