import 'package:flutter/material.dart';

class AppConstants {
  //Shared Preferences Keys
  static const String themeModeKey = 'isDarkModeKey';

  //Lists
  static const List<String> eventTags = [
    "Music",
    "Festival",
    "Workshop",
    "Conference",
    "Networking",
    "Meetup",
    "Talk",
    "Webinar",
    "Hackathon",
    "Fundraiser",
    "Charity",
    "Outdoor",
    "Indoor",
    "Sports",
    "Live",
    "Food",
    "Culture",
    "Art",
    "Theater",
    "Movie",
    "Party",
    "Community",
    "Business",
    "Startup",
    "Gaming",
    "Fashion",
    "Wellness",
    "Brunch",
    "Spiritual",
    "Book",
    "Quiet",
    "Loud",
    "Calm",
    "Cheap",
  ];
}

class AppTextStyle {
  AppTextStyle({required this.context});

  final BuildContext context;
  Color get eventCardPrimaryColor => Theme.of(context).colorScheme.primary;

  // Event Card Widget
  TextStyle get eventCardTitleText => TextStyle(
    color: eventCardPrimaryColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  TextStyle get eventCardData => TextStyle(
    color: eventCardPrimaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  static const TextStyle eventCardDescText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle eventCardSubText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w200,
  );

  //Event Card Brief Widget
  TextStyle get cardBriefTitleText => TextStyle(
    color: eventCardPrimaryColor,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  //Event Details Page
  static const TextStyle eventDetailsDesc = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle eventDetailsSubTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  TextStyle get eventDetailsBrief => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: eventCardPrimaryColor,
  );

  TextStyle get eventDetailsTitle => TextStyle(
    color: eventCardPrimaryColor,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  //Friend Brief Widget
  static const TextStyle friendUsername = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );
  static const TextStyle friendFullname = TextStyle(
    fontSize: 1,
    fontWeight: FontWeight.w200,
  );

  //Profile Page
  static const TextStyle profileFullname = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle profileDataNumber = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle profileDataDesc = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  static const TextStyle profileBio = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w200,
  );

  //Join Event Page
  static const TextStyle joinEventTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle joinEventDate = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle joinEventLocation = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle joinEventDescription = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static const TextStyle joinEventHeadline = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}
