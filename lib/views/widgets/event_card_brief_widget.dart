import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/data/constants.dart';

import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../pages/event_details_page.dart';

class EventCardBriefWidget extends ConsumerStatefulWidget {
  const EventCardBriefWidget({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventCardBriefWidget> createState() =>
      _EventCardBriefWidgetState();
}

class _EventCardBriefWidgetState extends ConsumerState<EventCardBriefWidget> {
  @override
  Widget build(BuildContext context) {
    Event event = ref
        .watch(eventProvider)
        .events
        .firstWhere((event) => event.id == widget.eventId);
    User loggedUser = ref.watch(loggedUserProvider).user;
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    bool hasLiked = event.likedUsers.contains(loggedUser.username);
    bool hasSaved = event.savedUsers.contains(loggedUser.username);

    //Event Data
    final String title = event.title;
    final String thumbnailSrc = event.thumbnailSrc;
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 225,
          height: 250,
          child: Column(
            children: [
              Expanded(child: Image.asset(thumbnailSrc, fit: BoxFit.cover)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  title,
                  style: AppTextStyle(context: context).eventCardTitleText,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EventDetailsPage(eventId: event.id);
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.info, color: primaryColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          ref
                              .read(eventProvider.notifier)
                              .toggleLike(event.id, loggedUser.username);
                          if (hasLiked) {
                            loggedUser.likedEvents.remove(event.id);
                          } else {
                            loggedUser.likedEvents.add(event.id);
                          }
                        },
                        icon: Icon(
                          hasLiked ? Icons.favorite : Icons.favorite_outline,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        event.likedUsers.length.toString(),
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          ref
                              .read(eventProvider.notifier)
                              .toggleSave(event.id, loggedUser.username);
                          if (hasSaved) {
                            loggedUser.savedEvents.remove(event.id);
                          } else {
                            loggedUser.savedEvents.add(event.id);
                          }
                        },
                        icon: Icon(
                          hasSaved ? Icons.bookmark : Icons.bookmark_outline,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        event.savedUsers.length.toString(),
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Icon(Icons.share, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
