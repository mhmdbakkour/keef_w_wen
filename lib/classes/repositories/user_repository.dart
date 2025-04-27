import 'dart:convert';

import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../data/user.dart';

class UserRepository {
  final StorageService storageService;
  final ApiService apiService;

  UserRepository({required this.storageService, required this.apiService});

  Future<List<User>> fetchLocalUsers() async {
    return storageService.fetchUsersFromFile();
  }

  Future<List<User>> fetchRemoteUsers() async {
    final response = await apiService.get('users/');
    final List decoded = jsonDecode(response.body);
    print(decoded);
    return decoded.map((e) => User.fromJson(e)).toList();
  }
}
