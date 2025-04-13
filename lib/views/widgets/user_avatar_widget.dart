import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/data/notifiers.dart';

import '../../classes/data/user.dart';
import '../pages/view_profile_page.dart';

class UserAvatarWidget extends ConsumerWidget {
  final User user;

  const UserAvatarWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? loggedUser = ref.watch(loggedUserProvider).user;

    return InkWell(
      onTap: () {
        if (loggedUser != null && user.username == loggedUser.username) {
          Navigator.popUntil(context, ModalRoute.withName('/main'));
          selectedPageNotifier.value = 4;
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ViewProfilePage(user: user);
              },
            ),
          );
        }
      },
      child:
          user.profileSource != null && user.profileSource!.isNotEmpty
              ? CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(user.profileSource!),
              )
              : CircleAvatar(radius: 25, child: Text(user.fullname[0])),
    );
  }
}
