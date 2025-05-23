import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keef_w_wen/data/constants.dart';
import 'package:keef_w_wen/views/pages/event_participants_page.dart';
import 'package:keef_w_wen/views/pages/join_event_page.dart';
import 'package:keef_w_wen/views/pages/view_profile_page.dart';
import 'package:keef_w_wen/views/widgets/rating_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../classes/data/event.dart';
import '../../classes/data/event_image.dart';
import '../../classes/data/participant.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
import '../widgets/qr_scanner_widget.dart';
import 'event_lobby_page.dart';

class EventDetailsPage extends ConsumerWidget {
  const EventDetailsPage({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailColor = Theme.of(context).colorScheme.primary;
    final Event? event = ref.watch(singleEventProvider(eventId));
    List<User> users = ref.watch(userProvider).users;
    User? loggedUser = ref.watch(loggedUserProvider).user;
    final locations = ref.watch(locationProvider).locations;

    final eventLocation = locations.firstWhere(
      (location) => location.id == event!.location,
    );

    if (event == null) {
      return const Center(child: Text("Event not found"));
    }

    bool userAttends =
        event.participants
            .where((user) => user.username == loggedUser.username)
            .toList()
            .isNotEmpty;

    //Event data
    final String title = event.title;
    final String description = event.description;
    final String thumbnail = event.thumbnail;
    final List<EventImage> images = event.images;
    final String hostOwner = event.hostOwner;
    final bool isPrivate = event.isPrivate;
    final bool needsId = event.needsId;
    final DateTime dateStart = event.dateStart;
    final bool openStatus = event.openStatus;
    final DateTime dateClosed = event.dateClosed;
    final int seats = event.seats;
    final double price = event.price;
    final double rating = event.rating;
    final List<String> tags = event.tags;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyle(context: context).eventDetailsTitle,
        ),
        centerTitle: true,
        actions:
            event.participants.any(
                  (participant) =>
                      participant.username == loggedUser.username &&
                      (participant.isHost ?? false),
                )
                ? [
                  IconButton(
                    icon: Icon(
                      Icons.qr_code_scanner,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        builder: (context) {
                          return SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ticket Scanner",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      color: Colors.black,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: 400,
                                          height: 400,
                                          child: QRScannerWidget(
                                            onDetect: (value) {
                                              final participant = event
                                                  .participants
                                                  .firstWhere(
                                                    (p) => p.id == value,
                                                    orElse:
                                                        () =>
                                                            Participant.empty(),
                                                  );

                                              Navigator.pop(context);

                                              final isValid =
                                                  participant.id == value;

                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  Future.delayed(
                                                    const Duration(seconds: 3),
                                                    () {
                                                      if (Navigator.of(
                                                        context,
                                                      ).canPop())
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                    },
                                                  );

                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    backgroundColor:
                                                        isValid
                                                            ? Colors
                                                                .green
                                                                .shade700
                                                            : Colors
                                                                .red
                                                                .shade700,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 40,
                                                            horizontal: 24,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            isValid
                                                                ? Icons
                                                                    .check_circle
                                                                : Icons.cancel,
                                                            size: 64,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            isValid
                                                                ? "Welcome, ${participant.username}"
                                                                : "Access Denied",
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ]
                : [],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 275,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: event.images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return thumbnail.isNotEmpty
                              ? _buildImage(context, thumbnail)
                              : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.925,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              );
                        } else {
                          return images.isNotEmpty
                              ? _buildImage(context, images[index - 1].url)
                              : Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.925,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(description, style: AppTextStyle.eventDetailsDesc),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      users
                          .firstWhere((user) => user.username == hostOwner)
                          .fullname,
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Owner of the event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.portrait, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      eventLocation.name,
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Location of the event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.location_pin, color: detailColor),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      isPrivate ? "Private" : "Public",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Whether the event is public or private",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(
                      isPrivate ? Icons.visibility_off : Icons.visibility,
                      color: detailColor,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      needsId ? "ID required" : "Anyone can attend",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Attendee identification requirement",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(
                      needsId ? Icons.badge : Icons.public,
                      color: detailColor,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${DateFormat.jm().format(dateStart)} - ${DateFormat.yMMMd().format(dateStart)}",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Date of when the event starts",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.event_available, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      "${DateFormat.jm().format(dateClosed)} - ${DateFormat.yMMMd().format(dateClosed)}",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Date of when the event closes",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.event_note, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      openStatus ? "Open" : "Closed",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Whether the event is still join-able",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.door_sliding, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      seats != -1
                          ? "$seats seats"
                          : "Unlimited seats available",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Number of available seats",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.event_seat, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      price > 0
                          ? "${price.toString()} US dollars"
                          : "Free of charge",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Price of entry",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.attach_money, color: detailColor),
                  ),
                  ListTile(
                    title:
                        tags.isNotEmpty
                            ? Wrap(
                              spacing: 8,
                              children:
                                  tags.map((tag) {
                                    return ActionChip(
                                      label: Text(tag),
                                      onPressed: () {},
                                    );
                                  }).toList(),
                            )
                            : Text(
                              "None",
                              style:
                                  AppTextStyle(
                                    context: context,
                                  ).eventDetailsBrief,
                            ),
                    subtitle: Text(
                      "Tags associated with event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.tag),
                  ),
                  ListTile(
                    title: RatingWidget(rating: rating),
                    subtitle: Text(
                      "User rating of event",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.rate_review),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EventParticipantsPage(event: event);
                        },
                      ),
                    );
                  },
                  child: Text("View participants"),
                ),
                ElevatedButton(
                  onPressed: () => _showContact(context, event, users),
                  child: Text("Contact"),
                ),
                userAttends
                    ? FilledButton(
                      style: ElevatedButton.styleFrom(elevation: 2),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EventLobbyPage(eventId: event.id);
                            },
                          ),
                        );
                      },
                      child: Text("Enter"),
                    )
                    : FilledButton(
                      style: ElevatedButton.styleFrom(elevation: 2),
                      onPressed:
                          event.openStatus
                              ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return JoinEventPage(eventId: event.id);
                                    },
                                  ),
                                );
                              }
                              : null,
                      child: Text("Join"),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, String image) {
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: InkWell(
        child: SizedBox(
          height: 275,
          width: MediaQuery.of(context).size.width * 0.925,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(image, fit: BoxFit.cover),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return _buildImageDialog(context, image);
            },
          );
        },
      ),
    );
  }

  Widget _buildImageDialog(BuildContext context, String image) {
    return Dialog(
      backgroundColor: Colors.black.withAlpha(0),
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1,
          maxScale: 2,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.network(image, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  void _showContact(BuildContext context, Event event, List<User> users) {
    showDialog(
      context: context,
      builder: (context) {
        User eventOwner = users.firstWhere(
          (user) => user.username == event.hostOwner,
        );
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Much rounder corners
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Contact",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // More rounded
                  elevation: 1,
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ), // Primary color icon
                    title: Text(eventOwner.fullname),
                    subtitle: Text('@${eventOwner.username}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ViewProfilePage(user: eventOwner),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 5),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ), // More rounded
                  elevation: 1,
                  child: ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    ), // Primary color icon
                    title: Text(eventOwner.email),
                    onTap: () => _sendEmail(eventOwner.email),
                  ),
                ),
                SizedBox(height: 5),
                if (eventOwner.mobileNumber.isNotEmpty)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ), // More rounded
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                      ), // Primary color icon
                      title: Text(
                        (eventOwner.mobileNumber.trim().isNotEmpty)
                            ? "${eventOwner.mobileNumber.substring(0, 4)} "
                                "${eventOwner.mobileNumber.substring(4, 6)} "
                                "${eventOwner.mobileNumber.substring(6, 9)} "
                                "${eventOwner.mobileNumber.substring(9, 12)}"
                            : "Not available",
                      ),
                      onTap: () => _makeCall(eventOwner.mobileNumber),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email app';
    }
  }

  void _makeCall(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone app';
    }
  }
}
