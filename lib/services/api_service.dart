import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;
  final storage = FlutterSecureStorage();

  ApiService({required this.baseUrl});

  Future<http.Response> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    Map<String, String> headers = {};

    if (requiresAuth) {
      final accessToken = await _getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await http.get(url, headers: headers);
    _handleErrors(response);
    return response;
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (requiresAuth) {
      final accessToken = await _getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    _handleErrors(response);
    return response;
  }

  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (requiresAuth) {
      final accessToken = await _getAccessToken();
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    _handleErrors(response);
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    Map<String, String> headers = {};

    final accessToken = await _getAccessToken();
    headers['Authorization'] = 'Bearer $accessToken';

    final response = await http.delete(url, headers: headers);
    _handleErrors(response);
    return response;
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final refreshToken = await storage.read(key: 'refresh_token');
    final response = await http.post(
      Uri.parse('$baseUrl/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  Future<String?> _getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
