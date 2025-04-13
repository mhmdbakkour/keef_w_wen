import 'dart:convert';
import 'package:flutter/services.dart';
import '../classes/data/event.dart';
import '../classes/data/user.dart';

class StorageService {
  Future<List<User>> readUsersFromFile() async {
    try {
      // Load JSON file from the assets
      String jsonString = await rootBundle.loadString("assets/data/users.json");

      if (jsonString.isEmpty) {
        throw Exception("Users JSON file is empty");
      }

      // Decode the JSON data
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Map the decoded JSON list to EventData objects
      return jsonList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error reading Users JSON file: $e');
      return [];
    }
  }

  /// Read events from a JSON file in local storage
  Future<List<Event>> readEventsFromFile() async {
    try {
      // Load JSON file from the assets
      String jsonString = await rootBundle.loadString(
        "assets/data/events.json",
      );

      if (jsonString.isEmpty) {
        throw Exception("Events JSON file is empty");
      }

      // Decode the JSON data
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Map the decoded JSON list to EventData objects
      return jsonList.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      print('❌ Error reading Events JSON file: $e');
      return [];
    }
  }
}
