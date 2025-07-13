import 'dart:convert';
import 'dart:io'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceHttpClient {
  final String baseUrl = 'http://10.0.2.2:8000/api/';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final Map<String, String> headers = {
      'Accept': 'application/json', 
    };
    if (includeAuth) {
      final token = await secureStorage.read(key: 'authToken');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      } else {
      }
    }
    return headers;
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body, bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await _getHeaders(includeAuth: includeAuth);
      headers['Content-Type'] = 'application/json';
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body), 
      );
      print("POST Response status for $endpoint: ${response.statusCode}");
      print("POST Response body for $endpoint: ${response.body}");
      return response;
    } catch (e) {
      throw Exception('Failed to post data to $endpoint: $e');
    }
  }
  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await _getHeaders(includeAuth: includeAuth);
      final response = await http.get(
        url,
        headers: headers,
      );
      print("GET Response status for $endpoint: ${response.statusCode}");
      print("GET Response body for $endpoint: ${response.body}");
      return response;
    } catch (e) {
      throw Exception('Failed to get data from $endpoint: $e');
    }
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body, bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await _getHeaders(includeAuth: includeAuth);
      headers['Content-Type'] = 'application/json';
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body), 
      );
      print("PUT Response status for $endpoint: ${response.statusCode}");
      print("PUT Response body for $endpoint: ${response.body}");
      return response;
    } catch (e) {
      throw Exception('Failed to put data to $endpoint: $e');
    }
  }
  Future<http.Response> delete(String endpoint, {bool includeAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final headers = await _getHeaders(includeAuth: includeAuth);
      final response = await http.delete(
        url,
        headers: headers,
      );
      print("DELETE Response status for $endpoint: ${response.statusCode}");
      print("DELETE Response body for $endpoint: ${response.body}");
      return response;
    } catch (e) {
      throw Exception('Failed to delete data from $endpoint: $e');
    }
  }

  Future<http.Response> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    File? file,
    String fileFieldName = 'photo', 
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final request = http.MultipartRequest('POST', url);
      final commonHeaders = await _getHeaders(includeAuth: includeAuth);
      request.headers.addAll(commonHeaders);
      if (fields != null) {
        request.fields.addAll(fields);
      }
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fileFieldName, 
          file.path,
          filename: file.path.split('/').last, 
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("POST Multipart Response status for $endpoint: ${response.statusCode}");
      print("POST Multipart Response body for $endpoint: ${response.body}");

      return response;
    } catch (e) {
      throw Exception('Failed to post multipart data to $endpoint: $e');
    }
  }
  Future<http.Response> putMultipart(
    String endpoint, {
    Map<String, String>? fields,
    File? file,
    String fileFieldName = 'photo', 
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final request = http.MultipartRequest('PUT', url);
      final commonHeaders = await _getHeaders(includeAuth: includeAuth);
      request.headers.addAll(commonHeaders);
      if (fields != null) {
        request.fields.addAll(fields);
      }
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fileFieldName, 
          file.path, 
          filename: file.path.split('/').last, 
        ));
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("PUT Multipart Response status for $endpoint: ${response.statusCode}");
      print("PUT Multipart Response body for $endpoint: ${response.body}");

      return response;
    } catch (e) {
      throw Exception('Failed to put multipart data to $endpoint: $e');
    }
  }
}
