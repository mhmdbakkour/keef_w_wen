import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/views/pages/view_profile_page.dart';
import 'package:keef_w_wen/views/widgets/search_bar_widget.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../widgets/user_brief_widget.dart';

class PeoplePage extends ConsumerStatefulWidget {
  const PeoplePage({super.key});

  @override
  ConsumerState<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends ConsumerState<PeoplePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        List<User> users = ref.watch(userProvider).users;

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  _friendSection("From last event...", users),
                  _friendSection("Based on your interests", users),
                  _friendSection("Friends of friends", users),
                ],
              ),
            ),
            SearchBarWidget(hintText: "I wonder who that was..."),
          ],
        );
      },
    );
  }

  Widget _friendSection(String title, List<User> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return UserBriefWidget(user: user);
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
