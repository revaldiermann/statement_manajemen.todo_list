import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {

  static Future<bool> login(
    String email,
    String password,
  ) async {

    final response = await http.post(

      Uri.parse(
        'http://localhost:8080/login',
      ),

      body: {

        'email': email,
        'password': password,
      },
    );

    // DEBUG
    print(response.body);

    final data = jsonDecode(
      response.body,
    );

    return data['status'] == true;
  }
}
