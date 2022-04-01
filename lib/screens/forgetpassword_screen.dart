import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authController.dart';
import '../screens/auth_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static const routeName = "/forget-password";

  final _authController = Get.find<AuthController>();

  final _forgetkey = GlobalKey<FormState>();
  String email = "";
  _sendLink(BuildContext context) async {
    _forgetkey.currentState!.save();

    if (!_forgetkey.currentState!.validate()) {
      return;
    }

    _authController.forgetPassword(email).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Check your Email address',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
          ),
          elevation: 5.0,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              1000,
            ),
          ),
          backgroundColor: Colors.indigo,
        ),
      );
    }).then((_) {
      Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: mediaQuery.width * 0.4,
            child: Image.asset('assets/logo/logo.png'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.height * 0.01,
              horizontal: mediaQuery.width * 0.04,
            ),
            child: Text(
              'Forgot your password? No problem. Just let us know your email address and we will email you a password reset link that will allow you to choose a new one. ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.indigo.shade800,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: mediaQuery.width * 0.03,
                horizontal: mediaQuery.width * 0.1),
            child: Form(
              key: _forgetkey,
              child: TextFormField(
                onSaved: (value) {
                  email = value.toString();
                },
                validator: (value) {
                  if (!value!.isEmail) {
                    return 'Enter valid Email Address';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: Colors.indigo,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.indigo[300],
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.indigo,
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1.0,
                      color: Colors.indigo,
                    ),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Colors.indigo.shade100,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                cursorColor: Colors.indigo,
                enabled: true,
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _sendLink(context);
              },
              child: const Text('Send Link'))
        ],
      ),
    );
  }
}
