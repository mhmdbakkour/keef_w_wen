import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../data/user.dart';

class UserRepository {
  final StorageService storageService;
  final ApiService apiService;
  final storage = FlutterSecureStorage();

  UserRepository({required this.storageService, required this.apiService});

  Future<List<User>> fetchLocalUsers() async {
    return storageService.fetchUsersFromFile();
  }

  Future<List<User>> fetchRemoteUsers() async {
    final response = await apiService.get('users/');
    final List decoded = jsonDecode(response.body);
    return decoded.map((e) => User.fromJson(e)).toList();
  }

  Future<User> fetchCurrentUser() async {
    final response = await apiService.get('me/');
    final decoded = jsonDecode(response.body);
    return User.fromJson(decoded);
  }

  Future<void> register(Map<String, dynamic> userData) async {
    final response = await apiService.post(
      'register/',
      userData,
      requiresAuth: false,
    );
    print(response);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await apiService.post('token/', {
      'username': username,
      'password': password,
    });

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

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> refreshAccessToken() async {
    try {
      final tokenData = await apiService.refreshToken();
      await saveTokens(tokenData['access'], tokenData['refresh']);
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await storage.read(key: 'access_token');
    return token != null;
  }
}
