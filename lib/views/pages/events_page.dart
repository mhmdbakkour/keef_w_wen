import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/data/constants.dart';
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
  late List<Event> filteredEvents;

  @override
  void initState() {
    super.initState();
    filteredEvents = ref.read(eventProvider).events;
  }

  bool matchDate(DateTime date, String? filter) {
    if (filter == null) return true;

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    final conditionMap = {
      "Last Month": () {
        final lastMonth = DateTime(now.year, now.month - 1, now.day);
        return date.isAfter(lastMonth) && date.isBefore(now);
      },
      "Last Week": () {
        final lastWeek = now.subtract(const Duration(days: 7));
        return date.isAfter(lastWeek) && date.isBefore(now);
      },
      "Yesterday": () {
        final yesterday = startOfToday.subtract(const Duration(days: 1));
        return date.year == yesterday.year &&
            date.month == yesterday.month &&
            date.day == yesterday.day;
      },
      "Today": () {
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      },
      "Tomorrow": () {
        final tomorrow = startOfToday.add(const Duration(days: 1));
        return date.year == tomorrow.year &&
            date.month == tomorrow.month &&
            date.day == tomorrow.day;
      },
      "This Week": () {
        final endOfWeek = startOfToday.add(Duration(days: 7 - now.weekday));
        return date.isAfter(startOfToday) && date.isBefore(endOfWeek);
      },
      "This Month": () {
        final nextMonth =
            (now.month == 12)
                ? DateTime(now.year + 1, 1)
                : DateTime(now.year, now.month + 1);
        return date.isAfter(startOfToday) && date.isBefore(nextMonth);
      },
    };

    final condition = conditionMap[filter];
    return condition != null && condition();
  }

  @override
  Widget build(BuildContext context) {
    List<Event> events = ref.watch(eventProvider).events;

    return Stack(
      children: [
        ListView.builder(
          itemCount: filteredEvents.length,
          itemBuilder: (context, index) {
            if (filteredEvents.isNotEmpty) {
              Event event = filteredEvents[index];
              if (index == 0) {
                return Column(
                  children: [
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: EventCardWidget(eventId: event.id),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: EventCardWidget(eventId: event.id),
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
        SearchBarWidget(
          hintText: "Search events",
          items: events,
          availableFilters: {
            "Tags": AppConstants.eventTags,
            "Price": ["Free", "Paid"],
            "Start Date": [
              "Last Month",
              "Last Week",
              "Yesterday",
              "Today",
              "Tomorrow",
              "This Week",
              "This Month",
            ],
            "End Date": ["Today", "Tomorrow", "This Week", "This Month"],
            "Identification": ["Needs Id", "Does Not Need Id"],
            "Seats": ["Limited", "Unlimited"],
            "Rating": ["Under 1", "1-2", "2-3", "3-4", "4-5"],
            "Availability": ["Open", "Closed"],
          },
          searchFilter: (items, query, filters) {
            return items.where((event) {
              final matchQuery =
                  event.title.toLowerCase().contains(query.toLowerCase()) ||
                  event.description.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  event.tags.any(
                    (tag) => tag.toLowerCase().contains(query.toLowerCase()),
                  );
              final matchTag =
                  filters['Tags'] == null ||
                  event.tags.contains(filters['Tags']);
              final matchPrice =
                  filters['Price'] == null ||
                  (filters['Price'].contains("Free") && event.price == 0) ||
                  (filters['Price'].contains("Paid") && event.price > 0);
              final matchStartDate = matchDate(
                event.dateStart,
                filters['Start Date'],
              );
              final matchEndDate = matchDate(
                event.dateEnded,
                filters['End Date'],
              );
              final matchId =
                  filters['Identification'] == null ||
                  filters['Identification'].contains("Needs Id") &&
                      event.needsId ||
                  filters['Identification'].contains("Does Not Need Id") &&
                      !event.needsId;
              final matchSeats =
                  filters['Seats'] == null ||
                  (filters['Seats'].contains("Unlimited") &&
                      event.seats == -1) ||
                  (filters['Seats'].contains("Limited") && event.seats > 0);
              final matchRating =
                  filters['Rating'] == null ||
                  (filters['Rating'].contains("Under 1") && event.rating < 1) ||
                  (filters['Rating'].contains("1-2") &&
                          event.rating > 1 &&
                          event.rating <= 2 ||
                      (filters['Rating'].contains("2-3") &&
                          event.rating > 2 &&
                          event.rating <= 3) ||
                      (filters['Rating'].contains("3-4") &&
                          event.rating > 3 &&
                          event.rating <= 4) ||
                      (filters['Rating'].contains("4-5") && event.rating > 4));
              final matchAvailability =
                  filters['Availability'] == null ||
                  (filters['Availability'].contains("Open") &&
                      event.openStatus) ||
                  (filters['Availability'].contains("Closed") &&
                      !event.openStatus);

              return matchQuery &&
                  matchTag &&
                  matchPrice &&
                  matchStartDate &&
                  matchEndDate &&
                  matchId &&
                  matchSeats &&
                  matchRating &&
                  matchAvailability;
            }).toList();
          },
          onSearch: (results) {
            setState(() {
              filteredEvents = results;
            });
          },
        ),
      ],
    );
  }
}
