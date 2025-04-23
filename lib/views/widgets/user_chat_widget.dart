import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import '../../classes/data/user.dart';

class UserChatWidget extends ConsumerStatefulWidget {
  final User user;
  final String textMessage;
  final bool isSender;

  const UserChatWidget({
    super.key,
    required this.user,
    required this.textMessage,
    this.isSender = false,
  });

  @override
  ConsumerState<UserChatWidget> createState() => _UserChatWidgetState();
}

class _UserChatWidgetState extends ConsumerState<UserChatWidget> {
  User get user => widget.user;
  String get textMessage => widget.textMessage;
  bool get isSender => widget.isSender;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        User? loggedUser = ref.watch(loggedUserProvider).user;
        return GestureDetector(
          onLongPress: () => _showMessageOptions(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Align(
              alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Card(
                color:
                    isSender
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          user.username,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color:
                                isSender
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer
                                    : Theme.of(
                                      context,
                                    ).colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                      Text(
                        textMessage,
                        style: TextStyle(
                          color:
                              isSender
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                isSender
                    ? [
                      ListTile(
                        leading: Icon(Icons.copy),
                        title: Text("Copy"),
                        onTap: () {
                          Navigator.pop(context);
                          // handle copy
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text("Delete"),
                        onTap: () {
                          Navigator.pop(context);
                          // handle delete
                        },
                      ),
                    ]
                    : [
                      ListTile(
                        leading: Icon(Icons.reply),
                        title: Text("Reply"),
                        onTap: () {
                          Navigator.pop(context);
                          // handle reply
                        },
                      ),
                    ],
          ),
        );
      },
    );
  }
}
