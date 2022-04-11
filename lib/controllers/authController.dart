import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../screens/navbar.dart';
import '../models/user.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {
  String tokens = "";
  var ftoken = "".obs;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
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

  login(
    String email,
    String password,
    String token,
    BuildContext context,
  ) async {
    final url =
        Uri.parse('https://hamroelectronics.com.np/api/596810BITS/login');

    final jsons = {'email': email, 'password': password, 'deviceToken': token};

    print(token);

    final response = await http
        .post(url, body: jsons, headers: {'Accept': 'application/json'});

    var body = json.decode(response.body) as Map<String, dynamic>;

    print(body);

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (response.statusCode != 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
          content: Text(
            body['message'][0].toString(),
          ),
        ),
      );
    }

    if (response.statusCode == 201) {
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('token', body['token']);

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

    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
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
    String photopath,
  ) async {
    final url = Uri.parse('https://hamroelectronics.com.np/api/user/update');

    if (photopath == '') {
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
    } else {
      final jsons = {
        'userid': uid,
        'name': uname,
        'phone': uphone,
        'address': uaddress,
        'oldpassword': opassword,
        'newpassword': npassword,
        'cpassword': cpassword,
        'deviceToken': token,
        'photopath': photopath,
      };
      Map<String, String> headers = {
        'Content-Type': "multipart/form-data",
        'Accept': 'application/json',
      };

      var request = http.MultipartRequest('POST', url)
        ..fields.addAll(jsons)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('photopath', photopath));

      var response = await request.send();

      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  facebook(BuildContext context) async {
    print('i am facebook');

    final LoginResult result = await FacebookAuth.instance.login();

    print('i am facebook');

    if (result.status == LoginStatus.success) {
      final url = Uri.parse(
          'https://hamroelectronics.com.np/api/596810BITS/user/createfromfb');

      var token = result.accessToken!.token.toString();
      final userData = await FacebookAuth.instance.getUserData();

      String name = userData['name'];
      String? email = userData['email'];
      String id = userData['id'];

      await FirebaseMessaging.instance.getToken().then((token) {
        ftoken.value = token.toString();
      });
      FirebaseMessaging.instance.subscribeToTopic('all');

      final jsons = {
        'email': email ?? '',
        'name': name,
        'id': id,
        'deviceToken': ftoken.toString()
      };

      print(email);
      print(name);
      print(id);
      print(ftoken);

      print('i am facebook');

      final response = await http
          .post(url, body: jsons, headers: {'Accept': 'application/json'});

      print(response.body);

      var body = json.decode(response.body) as Map<String, dynamic>;

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      if (response.statusCode != 200) {
        print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                1000,
              ),
            ),
            content: const Text(
              'Something Went Wrong',
            ),
          ),
        );
      }

      if (response.statusCode == 200) {
        localStorage.setString('user', json.encode(body['check']));
        localStorage.setString('token', token);

        Navigator.of(context).pushReplacementNamed(Navbar.routeName);
      }
    } else {
      print(result.status);
      print(result.message);
    }
  }

  google(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    _googleSignIn.disconnect();

    final url = Uri.parse(
        'https://hamroelectronics.com.np/api/596810BITS/user/createfromgoogle');

    final userData = await _googleSignIn.signIn();

    print(userData!.displayName);

    String? name = userData.displayName;
    String? email = userData.email;
    String id = userData.id;

    print("$name Email $email id $id");

    await FirebaseMessaging.instance.getToken().then((token) {
      ftoken.value = token.toString();
    });
    FirebaseMessaging.instance.subscribeToTopic('all');

    final jsons = {
      'email': email,
      'name': name,
      'id': id,
      'deviceToken': ftoken.toString()
    };

    final response = await http
        .post(url, body: jsons, headers: {'Accept': 'application/json'});

    var body = json.decode(response.body) as Map<String, dynamic>;

    print(body['check']);
    print(body);

    SharedPreferences localStorage = await SharedPreferences.getInstance();

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
          content: const Text(
            'Something Went Wrong',
          ),
        ),
      );
    }

    if (response.statusCode == 200) {
      localStorage.setString('user', json.encode(body['check']));
      localStorage.setString('token', body['token']);

      Navigator.of(context).pushReplacementNamed(Navbar.routeName);
    }
  }
}
