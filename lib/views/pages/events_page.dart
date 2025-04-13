import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../classes/data/event.dart';
import '../../classes/providers.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/search_bar_widget.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        List<Event> events = ref.watch(eventProvider).events;

        return Stack(
          children: [
            ListView.builder(
              itemCount: events.isNotEmpty ? events.length : 5,
              itemBuilder: (context, index) {
                if (events.isNotEmpty) {
                  Event event = events[index];
                  if (index == 0) {
                    return Column(
                      children: [
                        SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: EventCardWidget(event: event),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: EventCardWidget(event: event),
                    );
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white10,
                      ),
                      height: 300,
                      width: double.infinity,
                    ),
                  );
                }
              },
            ),
            SearchBarWidget(hintText: "I wonder what's happening..."),
          ],
        );
      },
    );
  }
}
