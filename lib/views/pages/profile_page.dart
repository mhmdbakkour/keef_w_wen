import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/widgets/user_brief_widget.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../widgets/event_tab_widget.dart';

import 'edit_user_page.dart';
import 'login_page.dart';

enum EventFilter { saved, liked, hosted, owned }

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

//TODO: Allow the user to edit their profile
//TODO: Allow the user to delete their profile
class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Future<List<User>> _followersFuture;
  late Future<List<User>> _followingFuture;

  @override
  void initState() {
    super.initState();
    final repository = ref.read(userRepositoryProvider);
    final loggedUser = ref.read(loggedUserProvider).user;
    _followersFuture = repository.fetchUsers(loggedUser.followers);
    _followingFuture = repository.fetchUsers(loggedUser.following);
  }

  @override
  Widget build(BuildContext context) {
    UserRepository repository = ref.watch(userRepositoryProvider);
    List<Event> events = ref.watch(eventProvider).events;
    List<User> users = ref.watch(userProvider).users;
    final loggedUser = ref.watch(loggedUserProvider).user;

    List<String> followers = loggedUser.followers;
    List<String> following = loggedUser.following;

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
                      _userFollowers(loggedUser, repository),
                      _userFollowing(loggedUser, repository),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditUserPage()),
                  );
                },
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

  Widget _userFollowers(User loggedUser, UserRepository repository) {
    return FutureBuilder<List<User>>(
      future: _followersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading users"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No users available."));
        }

        final users = snapshot.data!;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            return UserBriefWidget(user: users[index]);
          },
        );
      },
    );
  }

  Widget _userFollowing(User loggedUser, UserRepository repository) {
    return FutureBuilder<List<User>>(
      future: _followingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading users"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No users available."));
        }

        final users = snapshot.data!;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            return UserBriefWidget(user: users[index]);
          },
        );
      },
    );
  }
}
