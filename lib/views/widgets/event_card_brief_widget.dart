import 'package:flutter/material.dart';
import 'package:keef_w_wen/data/constants.dart';

import '../../classes/data/event.dart';
import '../pages/event_details_page.dart';

class EventCardBriefWidget extends StatefulWidget {
  const EventCardBriefWidget({super.key, required this.event});

  final Event event;

  @override
  State<EventCardBriefWidget> createState() => _EventCardBriefWidgetState();
}

class _EventCardBriefWidgetState extends State<EventCardBriefWidget> {
  bool hasLiked = false;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Theme.of(context).colorScheme.primary;

    //Event Data
    final String title = widget.event.title;
    final String thumbnailSrc = widget.event.thumbnailSrc;

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
                            return EventDetailsPage(event: widget.event);
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.info, color: iconColor),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        hasLiked = !hasLiked;
                        if (hasLiked) {
                          widget.event.likes++;
                        } else {
                          if (widget.event.likes >= 0) {
                            widget.event.likes--;
                          } else {
                            widget.event.likes = 0;
                          }
                        }
                      });
                    },
                    icon: Icon(
                      hasLiked ? Icons.favorite : Icons.favorite_outline,
                      color: iconColor,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_outline, color: iconColor),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: Icon(Icons.share, color: iconColor),
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
