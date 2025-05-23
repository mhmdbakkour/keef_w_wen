import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/api_service.dart';
import '../data/user.dart';

class UserRepository {
  final ApiService apiService;
  final storage = FlutterSecureStorage();

  UserRepository({required this.apiService});

  Future<List<User>> fetchAllUsers() async {
    final response = await apiService.get('users/');
    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => User.fromJson(e)).toList();
  }

  //TODO: This runs twice and way too many times, but it works :)
  Future<List<User>> fetchUsers(List<String> usernames) async {
    final response = await apiService.post('users/bulk-fetch/', {
      'usernames': usernames,
    });
    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => User.fromJson(e)).toList();
  }

  Future<User> fetchCurrentUser() async {
    final response = await apiService.get('me/');
    final decoded = jsonDecode(response.body);
    return User.fromJson(decoded);
  }

  Future<void> register(
    Map<String, dynamic> userData,
    File? profilePicture,
  ) async {
    final response = await apiService.postMultipart(
      endpoint: 'register/',
      rawFields: userData,
      files: profilePicture != null ? [profilePicture] : [],
      fileField: 'profile_picture',
      requiresAuth: false,
    );
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await apiService.post('token/', {
      'username': username,
      'password': password,
    }, requiresAuth: false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveTokens(data['access'], data['refresh']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
  }

  Future<User> updateUser(
    String username,
    Map<String, dynamic> userData,
    File? file,
  ) async {
    try {
      final response = await apiService.patch('users/$username/', userData);
      final json = jsonDecode(response.body);

      if (file != null) {
        final pictureUrl = await updateProfilePicture(file, username);
        json['profile_picture'] = pictureUrl;
      }

      return User.fromJson(json);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String username) async {
    final response = await apiService.delete('users/$username/');

    if (response.statusCode != 204) {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }

  Future<String> updateProfilePicture(File file, String username) async {
    final response = await apiService.patchMultipart(
      endpoint: 'users/$username/',
      rawFields: {},
      files: [file],
      fileField: 'profile_picture',
    );

    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Failed to upload: $responseBody');
    }

    final pictureUrl =
        jsonDecode(await response.stream.bytesToString())['profile_picture'];
    return pictureUrl;
  }

  Future<void> followUser(String follower, String following) async {
    final response = await apiService.post('follow/', {
      "follower": follower,
      "following": following,
    });

    if (response.statusCode == 201) {
      // User followed successfully
      print('Successfully followed $following');
    } else if (response.statusCode == 200) {
      // User unfollowed successfully
      print('Successfully unfollowed $following');
    } else {
      // Handle error or other responses
      print('Error: ${response.statusCode}');
    }
  }

  Future<List<String>> getFollowers(String username) async {
    final response = await apiService.get('users/$username/followers/');

    if (response.statusCode == 200) {
      List<dynamic> followersData = jsonDecode(response.body);
      return followersData
          .cast<String>(); // Converting dynamic list to List<String>
    } else {
      throw Exception('Failed to load followers');
    }
  }

  Future<List<String>> getFollowing(String username) async {
    final response = await apiService.get('users/$username/following/');

    if (response.statusCode == 200) {
      List<dynamic> followingData = jsonDecode(response.body);
      return followingData
          .cast<String>(); // Converting dynamic list to List<String>
    } else {
      throw Exception('Failed to load following');
    }
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> refreshAccessToken() async {
    try {
      final tokenData = await apiService.refreshToken();
      await saveTokens(
        tokenData['access'],
        tokenData['refresh'] ?? await storage.read(key: 'refresh_token'),
      );
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  Future<Map<String, bool>> checkUserAvailability({
    String? username,
    String? email,
  }) async {
    String endpoint = 'check-user/';
    List<String> params = [];

    if (username != null) params.add('username=$username');
    if (email != null) params.add('email=$email');

    if (params.isNotEmpty) {
      endpoint += '?${params.join('&')}';
    }

    final response = await apiService.get(endpoint, requiresAuth: false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'username': data['username'] ?? true,
        'email': data['email'] ?? true,
      };
    } else {
      throw Exception('Failed to check user availability: ${response.body}');
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await storage.read(key: 'access_token');
    return token != null;
  }

  String generateAssociatedColor() {
    final random = Random();

    while (true) {
      final r = random.nextInt(171) + 50;
      final g = random.nextInt(171) + 50;
      final b = random.nextInt(171) + 50;

      final luminance = 0.299 * r + 0.587 * g + 0.114 * b;

      if (luminance > 130 && luminance < 230) {
        final value = (0xFF << 24) | (r << 16) | (g << 8) | b;
        return '0x${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
      }
    }
  }
}
