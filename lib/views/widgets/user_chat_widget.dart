import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';

import '../../classes/data/user.dart';
import '../../data/constants.dart';
import '../../data/notifiers.dart';
import '../pages/view_profile_page.dart';

class UserChatWidget extends ConsumerWidget {
  final User user;
  final String textMessage;

  const UserChatWidget({
    super.key,
    required this.user,
    required this.textMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? loggedUser = ref.watch(loggedUserProvider).user;

    return ListTile(
      contentPadding: EdgeInsets.only(right: 4, left: 10),
      isThreeLine: true,
      visualDensity: VisualDensity.compact,

      leading:
          user.profileSource != null && user.profileSource!.isNotEmpty
              ? CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(user.profileSource!),
              )
              : CircleAvatar(
                radius: 20,
                child: Text(user.fullname[0].toUpperCase()),
              ),
      title: Text(
        loggedUser!.username == user.username ? "You" : user.username,
        style: AppTextStyle.chatTitle,
      ),
      subtitle: Text(textMessage, style: AppTextStyle.chatText),
      trailing: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        offset: Offset(-10, -5),
        icon: Icon(Icons.more_vert),
        onSelected: (value) {
          switch (value) {
            case 'view':
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
              break;
            case 'message':
              print('Send message to ${user.username}');
              break;
            case 'request':
              print('Request ${user.username}');
              break;
          }
        },
        itemBuilder:
            (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: 'view', child: Text('View Profile')),
              PopupMenuItem<String>(
                value: 'message',
                child: Text('Send Message'),
              ),
              PopupMenuItem<String>(
                value: 'request',
                child: Text('Friend request'),
              ),
            ],
      ),
    );
  }
}
