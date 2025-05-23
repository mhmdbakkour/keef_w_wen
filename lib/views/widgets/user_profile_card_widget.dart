import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';

class UserProfileCard extends ConsumerStatefulWidget {
  final User user;
  final VoidCallback onVisited;

  const UserProfileCard({
    super.key,
    required this.user,
    required this.onVisited,
  });

  @override
  ConsumerState<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends ConsumerState<UserProfileCard> {
  List<String> followers = [];
  List<String> following = [];

  @override
  void initState() {
    ref.read(userFollowersProvider(widget.user.username).notifier).refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    followers =
        ref.watch(userFollowersProvider(widget.user.username)).followers;
    following =
        ref.watch(userFollowersProvider(widget.user.username)).following;

    final theme = Theme.of(context);
    final displayName =
        (widget.user.fullname.trim().isNotEmpty)
            ? widget.user.fullname
            : widget.user.username;
    final displayMobile =
        (widget.user.mobileNumber.trim().isNotEmpty)
            ? "${widget.user.mobileNumber.substring(0, 4)} ${widget.user.mobileNumber.substring(4, 6)} ${widget.user.mobileNumber.substring(6, 9)} ${widget.user.mobileNumber.substring(9, 12)}"
            : "Not available";

    Widget profileImage =
        widget.user.profilePicture != null &&
                widget.user.profilePicture!.isNotEmpty
            ? Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(widget.user.profilePicture!),
                  fit: BoxFit.cover,
                ),
              ),
            )
            : Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: widget.user.associatedColor!.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: widget.user.associatedColor,
              ),
            );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            profileImage,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '@${widget.user.username}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.mail,
                        size: 16,
                        color: theme.colorScheme.primary.withAlpha(150),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          widget.user.email,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 16,
                        color: theme.colorScheme.primary.withAlpha(150),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          displayMobile,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${followers.length} followers • ${following.length} following',
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: widget.onVisited,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: const Text("Visit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
