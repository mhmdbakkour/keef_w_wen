import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/widgets/user_brief_widget.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../widgets/event_tab_widget.dart';

import 'login_page.dart';

enum EventFilter { saved, liked, hosted, owned }

class ProfilePage extends ConsumerStatefulWidget {
  final User loggedUser;

  const ProfilePage({super.key, required this.loggedUser});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  List<String> followers = [];
  List<String> following = [];

  @override
  void initState() {
    ref
        .read(userFollowersProvider(widget.loggedUser.username).notifier)
        .refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository repository = ref.watch(userRepositoryProvider);
    List<Event> events = ref.watch(eventProvider).events;
    List<User> users = ref.watch(userProvider).users;
    final loggedUser = widget.loggedUser;

    followers = ref.watch(userFollowersProvider(loggedUser.username)).followers;
    following = ref.watch(userFollowersProvider(loggedUser.username)).following;

    return Stack(
      children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Container(
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
                      loggedUser.profilePicture != null &&
                              loggedUser.profilePicture!.isNotEmpty
                          ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              loggedUser.profilePicture!,
                            ),
                          )
                          : CircleAvatar(
                            radius: 50,
                            backgroundColor: loggedUser.associatedColor,
                            child: Text(
                              loggedUser.fullname.isNotEmpty
                                  ? loggedUser.fullname[0]
                                  : loggedUser.username[0].toUpperCase(),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                      SizedBox(height: 10),
                      Text(
                        loggedUser.fullname.isNotEmpty
                            ? loggedUser.fullname
                            : loggedUser.username,
                        style: AppTextStyle.profileFullname,
                      ),
                      SizedBox(height: 5),
                      _buildUserBio(
                        loggedUser.bio.isNotEmpty
                            ? loggedUser.bio
                            : "Bio goes here...",
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _infoTile(
                            "Events",
                            events
                                .where(
                                  (event) =>
                                      event.hostOwner == loggedUser.username,
                                )
                                .length,
                          ),
                          _infoTile("Followers", followers.length),
                          _infoTile("Following", following.length),
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
                    Tab(icon: Icon(Icons.person_add), text: "Followers"),
                    Tab(icon: Icon(Icons.people), text: "Following"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      events.isNotEmpty
                          ? EventTabWidget()
                          : Center(child: Text("No events available.")),
                      _userFollowers(loggedUser, users),
                      _userFollowing(loggedUser, users),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FilledButton.icon(
              style: ElevatedButton.styleFrom(elevation: 4),
              label: Text("Logout"),
              icon: Icon(Icons.logout),
              onPressed: () async {
                await repository.logout();

                if (mounted) {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
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

  Widget _buildProfileActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.person),
                label: Text("Edit Profile"),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.share),
                label: Text("Share Profile"),
              ),
            ],
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

  Widget _userFollowers(User loggedUser, List<User> users) {
    if (users.isEmpty) {
      return Center(child: Text("No users available."));
    }
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
    if (users.isEmpty) {
      return Center(child: Text("No users available."));
    }
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
