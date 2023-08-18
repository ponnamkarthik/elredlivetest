import 'dart:convert';

import 'package:elredlivetest/models/screens_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;

  ApiService({
    required this.client,
  });

  Future<ScreensModel> fetchScreens() async {
    final uri = Uri.parse("https://api.npoint.io/5c5331aa05a4810ee08a");
    try {
      final http.Response response = await client.get(uri);

      if (response.statusCode != 200) {
        throw Exception("Error Status Code: ${response.statusCode}");
      }
      final screens = screensModelFromJson(response.body);
      return screens;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> postUserData(Map<String, String> data) async {
    final uri = Uri.parse("https://test1.elred.io/postUserInformation");
    // final uri = Uri.parse("https://dummy.restapiexample.com/api/v1/create");
    try {
      final http.Response response = await client.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception("Error Status Code: ${response.statusCode}");
      }
      print(response.body);
      final body = json.decode(response.body);

      if(body["success"] == true || body["status"] == "success") {
        return true;
      }

      throw Exception("Failed to Update data to server.");

    } catch (err) {
      print(err);
      rethrow;
    }
  }
}
