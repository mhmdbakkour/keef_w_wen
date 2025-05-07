import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';

import '../../classes/data/user.dart';
import '../../data/notifiers.dart';
import '../pages/view_profile_page.dart';

class UserBriefWidget extends ConsumerWidget {
  final User user;

  const UserBriefWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? loggedUser = ref.watch(loggedUserProvider).user;

    return ListTile(
      contentPadding: EdgeInsets.only(right: 4, left: 10),
      leading:
          user.profilePicture != null && user.profilePicture!.isNotEmpty
              ? CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.profilePicture!),
              )
              : CircleAvatar(
                radius: 25,
                backgroundColor: user.associatedColor,
                child: Text(
                  user.fullname.isNotEmpty
                      ? user.fullname[0].toUpperCase()
                      : user.username[0].toUpperCase(),
                ),
              ),
      title: Text(user.fullname.isNotEmpty ? user.fullname : user.username),
      subtitle: Text(user.username),
      trailing: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        offset: Offset(-10, -5),
        icon: Icon(Icons.more_vert),
        onSelected: (value) {
          switch (value) {
            case 'view':
              if (user.username == loggedUser.username) {
                if (ModalRoute.of(context)?.settings.name != '/main') {
                  Navigator.popUntil(context, ModalRoute.withName('/main'));
                }
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
              break;
            case 'message':
              print('Send message to ${user.username}');
              break;
            case 'follow':
              print('Followed ${user.username}');
              break;
          }
        },
        itemBuilder:
            (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'view',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('View Profile'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'message',
                child: ListTile(
                  leading: Icon(Icons.message),
                  title: Text('Send Message'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'follow',
                child: ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Follow'),
                ),
              ),
            ],
      ),
    );
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255, // Alpha value (opacity) 0 - 255
      random.nextInt(256), // Red channel (0 - 255)
      random.nextInt(256), // Green channel (0 - 255)
      random.nextInt(256), // Blue channel (0 - 255)
    );
  }
}
