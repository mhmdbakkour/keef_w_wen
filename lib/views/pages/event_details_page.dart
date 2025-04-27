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
import '../../classes/data/location.dart';
import '../../classes/data/user.dart';
import '../../classes/providers.dart';
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
    final User hostOwner = event.hostOwner;
    final Location location = event.location;
    final bool isPrivate = event.isPrivate;
    final bool hasIdentification = event.needsId;
    final DateTime dateStart = event.dateStart;
    final bool openStatus = event.openStatus;
    final DateTime dateClosed = event.dateClosed;
    final int seats = event.seats;
    final int likes = 5;
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
                          return _buildImage(context, thumbnail);
                        } else {
                          return _buildImage(context, images[index - 1].image);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(description, style: AppTextStyle.eventDetailsDesc),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text(
                      hostOwner.fullname,
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
                      location.name,
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
                      hasIdentification ? "Required" : "Not required",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Attendee identification requirement",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.verified, color: detailColor),
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
                      "$seats seats available",
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
                      "$likes likes received",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Number of likes made by users",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.favorite, color: detailColor),
                  ),
                  ListTile(
                    title: Text(
                      "${price.floor().toString()} US dollars",
                      style: AppTextStyle(context: context).eventDetailsBrief,
                    ),
                    subtitle: Text(
                      "Price of entry",
                      style: AppTextStyle.eventDetailsSubTitle,
                    ),
                    leading: Icon(Icons.attach_money, color: detailColor),
                  ),
                  ListTile(
                    title: Wrap(
                      spacing: 8,
                      children:
                          tags.map((tag) {
                            return ActionChip(
                              label: Text(tag),
                              onPressed: () {},
                            );
                          }).toList(),
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
      padding: EdgeInsets.only(right: 10),
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
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Contact",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Divider(thickness: 3),
                SizedBox(height: 15),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(eventOwner.fullname),
                  subtitle: Text(eventOwner.username),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProfilePage(user: eventOwner),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.alternate_email),
                  title: Text(eventOwner.email),
                  onTap: () => _sendEmail(eventOwner.email),
                ),
                eventOwner.mobileNumber.isNotEmpty
                    ? ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(eventOwner.mobileNumber.toString()),
                      onTap: () => _makeCall(eventOwner.mobileNumber),
                    )
                    : SizedBox.shrink(),
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
