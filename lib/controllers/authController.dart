import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth_screen.dart';
import '../screens/navbar.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  String tokens = "";

  register(User user, BuildContext context, String token) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/register');

    final jsons = {
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'password_confirmation': user.confirmpassword,
      'address': user.address,
      'phone': user.phone,
      'deviceToken': token,
    };

    final response = await http.post(url, body: jsons, headers: {
      'Accept': 'application/json',
    });

    final body = json.decode(response.body) as Map<String, dynamic>;

    print(response.body);

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            body['errors']
                .toString()
                .replaceAll('{', '')
                .replaceAll('}', '')
                .replaceAll('[', '')
                .replaceAll(']', ''),
          ),
        ),
      );
    }

    if (response.statusCode == 201) {
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('token', body['token']);
      tokens = localStorage.getString('token')!;

      Navigator.of(context).pushReplacementNamed(Navbar.routeName);
    }
  }

  login(String email, String password, BuildContext context) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/login');

    final jsons = {'email': email, 'password': password};

    final response = await http
        .post(url, body: jsons, headers: {'Accept': 'application/json'});

    var body = json.decode(response.body) as Map<String, dynamic>;

    print(body);

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            body['message'][0].toString(),
          ),
        ),
      );
    }

    if (response.statusCode == 201) {
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('token', body['token']);

      tokens = localStorage.getString('token')!;

      Navigator.of(context).pushReplacementNamed(Navbar.routeName);
    }
  }

  logout(BuildContext context) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/logout');

    await http.post(url, headers: {
      'Authorization': 'Bearer $tokens',
    });

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _prefs.remove('token');
    _prefs.remove('user');

    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  forgetPassword(String email) async {
    final url = Uri.parse(
        "https://hamroelectronics.com.np/api/596810BITS/forgot-password");

    final jsons = {'email': email};

    final response = await http
        .post(url, body: jsons, headers: {'Accept': 'application/json'});

    print(response.body);
  }

  updateUser(
    BuildContext context,
    String uid,
    String uname,
    String uemail,
    String uphone,
    String uaddress,
    String opassword,
    String npassword,
    String cpassword,
    String token,
  ) async {
    final url = Uri.parse('https://hamroelectronics.com.np/api/user/update');

    final jsons = {
      'userid': uid,
      'name': uname,
      'phone': uphone,
      'address': uaddress,
      'oldpassword': opassword,
      'newpassword': npassword,
      'cpassword': cpassword,
      'deviceToken': token,
    };

    final response = await http.post(url, body: jsons, headers: {
      'Accept': 'application/json',
    });

    final body = json.decode(response.body) as Map<String, dynamic>;

    print(body["id"]);

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('user', json.encode(body));
  }
}
