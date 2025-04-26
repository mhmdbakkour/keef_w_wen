import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url);
    _handleErrors(response);
    return response;
  }

  Future<http.Response> head(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.head(url);
    _handleErrors(response);
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    _handleErrors(response);
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url);
    _handleErrors(response);
    return response;
  }

  void _handleErrors(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
