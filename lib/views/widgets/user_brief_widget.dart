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
    final loggedUser = ref.watch(loggedUserProvider).user;

    return ListTile(
      contentPadding: const EdgeInsets.only(right: 4, left: 10),
      leading:
          (user.profilePicture != null && user.profilePicture!.isNotEmpty)
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
        key: ValueKey(user.username),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        offset: const Offset(-10, -5),
        icon: const Icon(Icons.more_vert),
        onSelected: (value) {
          Future.microtask(() {
            if (!context.mounted) return;
            final navigator = Navigator.of(context, rootNavigator: true);

            if (user.username != loggedUser.username) {
              switch (value) {
                case 'view':
                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => ViewProfilePage(user: user),
                    ),
                  );
                  break;
                case 'message':
                  print('Send message to ${user.username}');
                  break;
                case 'follow':
                  print('Followed ${user.username}');
                  break;
              }
            } else {
              switch (value) {
                case 'profile':
                  navigator.popUntil((route) => route.settings.name == '/main');
                  selectedPageNotifier.value = 4;
                  break;
              }
            }
          });
        },
        itemBuilder: (context) {
          if (user.username != loggedUser.username) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'view',
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('View Profile'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'message',
                child: ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Send Message'),
                ),
              ),
              PopupMenuItem<String>(
                value: 'follow',
                child: ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Follow'),
                ),
              ),
            ];
          } else {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                child: ListTile(
                  leading: const Icon(Icons.person_2),
                  title: const Text('Go to profile'),
                ),
              ),
            ];
          }
        },
      ),
    );
  }
}
