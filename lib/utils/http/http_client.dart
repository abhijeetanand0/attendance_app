import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHttpHelper {
  static const String _baseUrl =
      'http://172.20.10.2:8000';
  static const String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIxNTMzNTA0LCJpYXQiOjE3MTg5NDE1MDQsImp0aSI6ImM3ZGNlNjFjNzAyODRlNDE4ZWNlMmJiNDk0ZmQyNWMwIiwidXNlcl9pZCI6Mn0.lvCU9rj-P6uWi1ukOa5dOpNufDLtLSoav7s2Uk5u2ms";

  // Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // To make an authenticated post request
  static Future<Map<String, dynamic>> private_post(
      String endpoint, dynamic data, String access) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token
      },
      body: json.encode(data),

    );
    print(token);
    return _handleResponse(response);
  }

  // To make an authenticated get request
  static Future<Map<String, dynamic>> private_get(String endpoint, String access) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    });
    return _handleResponse(response);
  }

  // Handle the HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return json.decode('{"result": "404"}');
    }

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

}
