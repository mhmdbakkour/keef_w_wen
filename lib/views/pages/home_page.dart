import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/providers.dart';
import 'package:keef_w_wen/data/notifiers.dart';
import 'package:keef_w_wen/views/pages/create_event_page.dart';
import '../../classes/data/event.dart';
import '../../classes/data/user.dart';
import '../widgets/event_card_brief_widget.dart';

enum SortType { distance, price, rating, time }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Event> events = [];

  @override
  Widget build(BuildContext context) {
    final headingColor = Theme.of(context).colorScheme.tertiary;

    return Consumer(
      builder: (context, ref, child) {
        events = ref.watch(eventProvider).events;

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickActions(),
              _buildEventSection(
                "Featured Events",
                Icon(Icons.featured_play_list),
                headingColor,
                SortType.rating,
              ),
              _buildEventSection(
                "Popular Events",
                Icon(Icons.celebration),
                headingColor,
                SortType.rating,
              ),
              _buildEventSection(
                "Recommended Events",
                Icon(Icons.recommend),
                headingColor,
                SortType.rating,
              ),
              _buildEventSection(
                "Trending Events",
                Icon(Icons.trending_up),
                headingColor,
                SortType.rating,
              ),
              _buildEventSection(
                "Upcoming Events",
                Icon(Icons.share_arrival_time),
                headingColor,
                SortType.time,
              ),
              _buildEventSection(
                "Nearby Events",
                Icon(Icons.near_me),
                headingColor,
                SortType.distance,
              ),
              _buildEventSection(
                "Cost-saving Events",
                Icon(Icons.monetization_on),
                headingColor,
                SortType.price,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionButton(Icons.add, "Create Event", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CreateEventPage();
                },
              ),
            );
          }),
          _actionButton(Icons.event_available, "Join Event", () {
            selectedPageNotifier.value = 1;
          }),
          _actionButton(Icons.bookmark, "Saved Events", () {
            selectedPageNotifier.value = 4;
          }),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback? onPressed) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: IconButton(
            padding: EdgeInsets.all(12),
            highlightColor: Theme.of(
              context,
            ).colorScheme.onTertiaryContainer.withAlpha(80),
            onPressed: onPressed,
            icon: Icon(icon, size: 30, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildEventSection(
    String title,
    Icon icon,
    Color headingColor,
    SortType sortBy,
  ) {
    List<Event> sortedEvents = List.from(events);
    switch (sortBy) {
      case SortType.distance:
        sortedEvents.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case SortType.price:
        sortedEvents.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.time:
        sortedEvents.sort((a, b) => a.dateCreated.compareTo(b.dateCreated));
        break;
      case SortType.rating:
        sortedEvents.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon.icon, color: headingColor),
              SizedBox(width: 10),
              Baseline(
                baseline: 20,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: headingColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 275,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sortedEvents.isNotEmpty ? sortedEvents.length : 5,
              itemBuilder: (context, index) {
                if (sortedEvents.isNotEmpty) {
                  Event event =
                      sortedEvents[index]; // Declare event properly inside scope
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: EventCardBriefWidget(event: event),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white10,
                      ),
                      height: 250,
                      width: 225,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
