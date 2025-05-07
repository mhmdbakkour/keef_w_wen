import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApiService {
  final String baseUrl;
  final storage = FlutterSecureStorage();

  ApiService({required this.baseUrl});

  Future<http.Response> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    return requiresAuth
        ? _authenticatedRequest((accessToken) async {
          final headers = {'Authorization': 'Bearer $accessToken'};
          final response = await http.get(url, headers: headers);
          _handleErrors(response);
          return response;
        })
        : (() async {
          final response = await http.get(url);
          _handleErrors(response);
          return response;
        })();
  }

  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    return requiresAuth
        ? _authenticatedRequest((accessToken) async {
          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          };
          final response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          _handleErrors(response);
          return response;
        })
        : (() async {
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          );
          _handleErrors(response);
          return response;
        })();
  }

  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    return requiresAuth
        ? _authenticatedRequest((accessToken) async {
          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          };
          final response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          _handleErrors(response);
          return response;
        })
        : (() async {
          final response = await http.put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          );
          _handleErrors(response);
          return response;
        })();
  }

  Future<http.StreamedResponse> postMultipart({
    required String endpoint,
    required Map<String, dynamic> rawFields,
    List<File> files = const [],
    required String fileField,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', uri);

    rawFields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileField,
          file.path,
          contentType: MediaType.parse(
            lookupMimeType(file.path) ?? 'application/octet-stream',
          ),
        ),
      );
    }

    return requiresAuth
        ? _authenticatedRequest((accessToken) async {
          request.headers['Authorization'] = 'Bearer $accessToken';
          return await request.send();
        })
        : request.send();
  }

  Future<http.StreamedResponse> patchMultipart({
    required String endpoint,
    required Map<String, dynamic> rawFields,
    List<File> files = const [],
    required String fileField,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl/$endpoint');

    final request = http.MultipartRequest('PATCH', uri);

    rawFields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    for (var file in files) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileField,
          file.path,
          contentType: MediaType.parse(
            lookupMimeType(file.path) ?? 'application/octet-stream',
          ),
        ),
      );
    }

    return requiresAuth
        ? _authenticatedRequest((accessToken) async {
          request.headers['Authorization'] = 'Bearer $accessToken';
          return await request.send();
        })
        : request.send();
  }

  Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    return requiresAuth
        ? _authenticatedRequest((accessToken) async {
          final headers = {'Authorization': 'Bearer $accessToken'};
          final response = await http.delete(url, headers: headers);
          _handleErrors(response);
          return response;
        })
        : (() async {
          final response = await http.delete(url);
          _handleErrors(response);
          return response;
        })();
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
    try {
      final accessToken = await storage.read(key: 'access_token');
      return accessToken;
    } catch (e) {
      throw Exception("Could not access token from storage: $e");
    }
  }

  Future<T> _authenticatedRequest<T>(
    Future<T> Function(String accessToken) request,
  ) async {
    // Get the current access token from secure storage
    String? accessToken = await _getAccessToken();

    try {
      // Try to perform the request with the current access token
      return await request(accessToken!);
    } on Exception {
      // If the token is invalid/expired, refresh the token and try again
      final refreshResponse = await refreshToken();
      final newAccessToken = refreshResponse['access'];
      // Store the new access token securely
      await storage.write(key: 'access_token', value: newAccessToken);

      // Try the request again with the new access token
      return await request(newAccessToken!);
    }
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
