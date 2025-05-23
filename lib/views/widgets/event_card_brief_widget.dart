import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/data/constants.dart';
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
  bool hasLiked = false;
  bool hasSaved = false;
  int likes = 0;
  int saves = 0;

  @override
  void initState() {
    super.initState();

    final interaction = ref.read(
      singleEventInteractionProvider(widget.eventId),
    );
    if (interaction != null) {
      hasLiked = interaction.liked;
      hasSaved = interaction.saved;
      likes = interaction.likesCount;
      saves = interaction.savesCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(singleEventProvider(widget.eventId));
    final interaction = ref.watch(
      singleEventInteractionProvider(widget.eventId),
    );
    final eventInteractionNotifier = ref.read(
      eventInteractionProvider.notifier,
    );
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (event == null) {
      return const SizedBox.shrink();
    }

    if (interaction != null) {
      hasLiked = interaction.liked;
      hasSaved = interaction.saved;
      likes = interaction.likesCount;
      saves = interaction.savesCount;
    }

    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 225,
          height: 250,
          child: Column(
            children: [
              Expanded(
                child:
                    event.thumbnail.isNotEmpty
                        ? Image.network(event.thumbnail, fit: BoxFit.cover)
                        : Container(
                          width: 255,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  event.title,
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
                          builder: (_) => EventDetailsPage(eventId: event.id),
                        ),
                      );
                    },
                    icon: Icon(Icons.info, color: primaryColor),
                  ),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          eventInteractionNotifier.likeEvent(event.id);
                        },
                        icon: Icon(
                          hasLiked ? Icons.favorite : Icons.favorite_outline,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        likes.toString(),
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          eventInteractionNotifier.saveEvent(event.id);
                        },
                        icon: Icon(
                          hasSaved ? Icons.bookmark : Icons.bookmark_outline,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        saves.toString(),
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
