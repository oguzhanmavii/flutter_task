import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert';

class LoginService {
  Future<bool> login(String email, String password) async {
    try {
      Response response = await post(
        Uri.parse('https://reqres.in/api/register'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        var data = jsonDecode(response.body.toString());
        print('Token: ${data['token']}');
        print('Login successful');
        return true;
      } else {
        // Unsuccessful login
        var error = jsonDecode(response.body.toString());
        print('Login failed: ${error['error']}');
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        print('Network error: $e');
      } else if (e is FormatException) {
        print('Error decoding JSON: $e');
      } else {
        print('Unexpected error: $e');
      }
      return false;
    }
  }
}
