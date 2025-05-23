import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/data/notifiers.dart';
import 'package:keef_w_wen/views/pages/view_profile_page.dart';
import 'package:keef_w_wen/views/widgets/search_bar_widget.dart';
import 'package:keef_w_wen/views/widgets/user_profile_card_widget.dart';
import '../../classes/data/user.dart';

class PeoplePage extends ConsumerStatefulWidget {
  const PeoplePage({super.key});

  @override
  ConsumerState<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends ConsumerState<PeoplePage> {
  late List<User> filteredUsers;

  @override
  void initState() {
    super.initState();
    filteredUsers = ref.read(userProvider).users;
  }

  @override
  Widget build(BuildContext context) {
    List<User> users = ref.watch(userProvider).users;
    User loggedUser = ref.watch(loggedUserProvider).user;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  User user = filteredUsers[index];
                  return UserProfileCard(
                    user: user,
                    onVisited: () {
                      if (user.username == loggedUser.username) {
                        Navigator.popUntil(
                          context,
                          (route) => route.settings.name == '/main',
                        );
                        selectedPageNotifier.value = 4;
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewProfilePage(user: user),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        SearchBarWidget(
          hintText: "Search people",
          items: users,
          searchFilter: (items, query, filters) {
            return items.where((user) {
              final matchQuery =
                  user.fullname.toLowerCase().contains(query.toLowerCase()) ||
                  user.username.toLowerCase().contains(query.toLowerCase()) ||
                  user.email.contains(query.toLowerCase()) ||
                  user.mobileNumber.toString().contains(query);
              return matchQuery;
            }).toList();
          },
          onSearch: (results) {
            setState(() {
              filteredUsers = results;
            });
          },
        ),
      ],
    );
  }
}
