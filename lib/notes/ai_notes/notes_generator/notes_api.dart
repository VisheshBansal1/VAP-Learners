import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class NotesApi {
  static const String _baseUrl =
      "https://vap-learners-backend.onrender.com"; 

  static Future<String> generateSection(String topic) async {
    try {
      final response = await http
          .post(
            Uri.parse("$_baseUrl/generate-note"),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode({
              "noteId": "temp",
              "topic": topic,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          "Server error ${response.statusCode}: ${response.body}",
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded == null ||
          decoded['sections'] == null ||
          decoded['sections'].isEmpty) {
        throw Exception("Invalid AI response");
      }

      return decoded['sections'].last['content'];
    } on SocketException {
      throw Exception("Cannot connect to server. Is backend running?");
    } on FormatException {
      throw Exception("Invalid JSON received from server");
    } catch (e) {
      throw Exception("Failed to generate section: $e");
    }
  }
}
