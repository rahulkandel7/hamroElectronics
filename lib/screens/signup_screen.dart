import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamro_electronics/models/user.dart';
import 'package:hamro_electronics/screens/login_screen.dart';

import 'package:url_launcher/url_launcher.dart';

import '../controllers/authController.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';

  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupKey = GlobalKey<FormState>();

  //Sign UP Focus Nodes
  final FocusNode _signupEmail = FocusNode();
  final FocusNode _signuppassword = FocusNode();
  final FocusNode _signupcpassword = FocusNode();
  final FocusNode _signupphone = FocusNode();
  final FocusNode _signupaddress = FocusNode();

  void _launchBITS() async {
    if (!await launch(
      "https://www.bitmapitsolution.com",
      forceWebView: false,
      forceSafariVC: false,
    )) throw 'Could not launch ';
  }

  final _authController = Get.put(AuthController());

  var _user = User(
    name: '',
    email: '',
    password: '',
    confirmpassword: '',
    profile: '',
    phone: '',
    address: '',
  );

  @override
  void dispose() {
    super.dispose();

    _signupEmail.dispose();
    _signuppassword.dispose();
    _signupcpassword.dispose();
    _signupphone.dispose();
    _signupaddress.dispose();
  }

  late String tokens;
  bool isLoading = false;

  userRegister() async {
    _signupKey.currentState!.save();

    if (!_signupKey.currentState!.validate()) {
      return;
    }
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        tokens = token.toString();
      });
    }).then((_) {
      _authController.register(_user, context, tokens);
      FirebaseMessaging.instance.subscribeToTopic('all');

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 0.6,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    CustomPaint(
                      size: Size(
                          double.infinity,
                          (400 * 0.22222222222222224)
                              .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                      painter: RPSCustomPainter(),
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.7598,
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: mediaQuery.width * 0.5,
                                child: Image.asset('assets/logo/logo.png'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: mediaQuery.width * 0.06,
                                  vertical: mediaQuery.height * 0.03,
                                ),
                                child: Form(
                                  key: _signupKey,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: mediaQuery.height * 0.01),
                                        child: TextFormField(
                                          onSaved: (value) {
                                            _user = User(
                                              name: value.toString(),
                                              email: _user.email,
                                              password: _user.password,
                                              confirmpassword:
                                                  _user.confirmpassword,
                                              profile: _user.profile,
                                              phone: _user.phone,
                                              address: _user.address,
                                            );
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(_signupEmail);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Name Field Required';
                                            }
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            errorStyle: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.red.shade800,
                                                ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            labelText: 'Full Name',
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo[300],
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: Colors.indigo,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo.shade100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          cursorColor: Colors.indigo,
                                          enabled: true,
                                          enableSuggestions: true,
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),
                                      //Email Field
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: mediaQuery.height * 0.02),
                                        child: TextFormField(
                                          focusNode: _signupEmail,
                                          onSaved: (value) {
                                            _user = User(
                                              name: _user.name,
                                              email: value.toString(),
                                              password: _user.password,
                                              confirmpassword:
                                                  _user.confirmpassword,
                                              profile: _user.profile,
                                              phone: _user.phone,
                                              address: _user.address,
                                            );
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(_signuppassword);
                                          },
                                          validator: (value) {
                                            if (value!.isEmail) {
                                              return null;
                                            } else {
                                              return 'Email Field Required';
                                            }
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            errorStyle: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.red.shade800,
                                                ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            labelText: 'Email Address',
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo[300],
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.email,
                                              color: Colors.indigo,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo.shade100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          cursorColor: Colors.indigo,
                                          enabled: true,
                                          enableSuggestions: true,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      //Password Field
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: mediaQuery.height * 0.02,
                                        ),
                                        child: TextFormField(
                                          focusNode: _signuppassword,
                                          onSaved: (value) {
                                            _user = User(
                                              name: _user.name,
                                              email: _user.email,
                                              password: value.toString(),
                                              confirmpassword:
                                                  _user.confirmpassword,
                                              profile: _user.profile,
                                              phone: _user.phone,
                                              address: _user.address,
                                            );
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(_signupcpassword);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Password Field Required';
                                            } else if (value.length < 8) {
                                              return 'Password Length Should be more than 8 characters';
                                            } else {
                                              return null;
                                            }
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            errorStyle: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.red.shade800,
                                                ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo[300],
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: Colors.indigo,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo.shade100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          cursorColor: Colors.indigo,
                                          enabled: true,
                                          enableSuggestions: true,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                        ),
                                      ),
                                      //Confirm Password
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: mediaQuery.height * 0.02,
                                        ),
                                        child: TextFormField(
                                          focusNode: _signupcpassword,
                                          onSaved: (value) {
                                            _user = User(
                                              name: _user.name,
                                              email: _user.email,
                                              password: _user.password,
                                              confirmpassword: value.toString(),
                                              profile: _user.profile,
                                              phone: _user.phone,
                                              address: _user.address,
                                            );
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(_signupphone);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Confirm Password Field Required';
                                            } else if (value !=
                                                _user.password) {
                                              return 'Password and Confirm Password Should Match';
                                            } else {
                                              return null;
                                            }
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: 'Confirm Password',
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo[300],
                                            ),
                                            errorStyle: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.red.shade800,
                                                ),
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: Colors.indigo,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo.shade100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          cursorColor: Colors.indigo,
                                          enabled: true,
                                          enableSuggestions: true,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                        ),
                                      ),
                                      //Phone Number
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: mediaQuery.height * 0.02,
                                        ),
                                        child: TextFormField(
                                          focusNode: _signupphone,
                                          onSaved: (value) {
                                            _user = User(
                                              name: _user.name,
                                              email: _user.email,
                                              password: _user.password,
                                              confirmpassword:
                                                  _user.confirmpassword,
                                              profile: _user.profile,
                                              phone: value.toString(),
                                              address: _user.address,
                                            );
                                          },
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(_signupaddress);
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Phone Number is Required';
                                            } else if (value.length != 10) {
                                              return 'Enter Valid Phone Number';
                                            } else {
                                              return null;
                                            }
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: 'Mobile Number',
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            errorStyle: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.red.shade800,
                                                ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo[300],
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.phone_android,
                                              color: Colors.indigo,
                                            ),
                                            prefixText: '+977-',
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo.shade100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          cursorColor: Colors.indigo,
                                          enabled: true,
                                          enableSuggestions: true,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      //Address Field
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: mediaQuery.height * 0.02),
                                        child: TextFormField(
                                          focusNode: _signupaddress,
                                          onSaved: (value) {
                                            _user = User(
                                              name: _user.name,
                                              email: _user.email,
                                              password: _user.password,
                                              confirmpassword:
                                                  _user.confirmpassword,
                                              profile: _user.profile,
                                              phone: _user.phone,
                                              address: value.toString(),
                                            );
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Address is Required';
                                            } else {
                                              return null;
                                            }
                                          },
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: 'Address',
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.red,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            errorStyle: Theme.of(context)
                                                .textTheme
                                                .caption
                                                ?.copyWith(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.red.shade800,
                                                ),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.indigo[300],
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.location_on,
                                              color: Colors.indigo,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1.0,
                                                color: Colors.indigo.shade100,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          cursorColor: Colors.indigo,
                                          enabled: true,
                                          enableSuggestions: true,
                                          keyboardType: TextInputType.text,
                                        ),
                                      ),

                                      //Signup Button

                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: mediaQuery.height * 0.01),
                                        child: SizedBox(
                                          width: mediaQuery.width * 0.35,
                                          child: ElevatedButton(
                                            onPressed: () => userRegister(),
                                            style: ElevatedButton.styleFrom(
                                              enableFeedback: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Sign Up',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 3.0),
                                                  child: Icon(
                                                    Icons.login,
                                                    size: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const LoginScreen(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                const begin = Offset(1.0, 0.0);
                                                const end = Offset.zero;
                                                const curve =
                                                    Curves.easeOutBack;

                                                var tween = Tween(
                                                        begin: begin, end: end)
                                                    .chain(CurveTween(
                                                        curve: curve));

                                                return SlideTransition(
                                                  position:
                                                      animation.drive(tween),
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(left: 6.0),
                                          child: Text(
                                            "Already have an account ? LogIn",
                                            style: TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          _launchBITS();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            top: mediaQuery.height * 0.01,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Powered By:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: mediaQuery.width *
                                                        0.02),
                                                child: Text(
                                                  'BITS',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red[800],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: Size(
                          double.infinity,
                          (400 * 0.22222222222222224)
                              .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                      painter: RPPSCustomPainter(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.4000000);
    path_0.lineTo(size.width * 0.02381944, size.height * 0.4834375);
    path_0.cubicTo(
        size.width * 0.04763889,
        size.height * 0.5656250,
        size.width * 0.09513889,
        size.height * 0.7343750,
        size.width * 0.1430556,
        size.height * 0.7834375);
    path_0.cubicTo(
        size.width * 0.1904861,
        size.height * 0.8343750,
        size.width * 0.2381944,
        size.height * 0.7656250,
        size.width * 0.2854167,
        size.height * 0.6834375);
    path_0.cubicTo(
        size.width * 0.3333333,
        size.height * 0.6000000,
        size.width * 0.3812500,
        size.height * 0.5000000,
        size.width * 0.4284722,
        size.height * 0.4165625);
    path_0.cubicTo(
        size.width * 0.4761806,
        size.height * 0.3343750,
        size.width * 0.5236111,
        size.height * 0.2656250,
        size.width * 0.5715278,
        size.height * 0.3165625);
    path_0.cubicTo(
        size.width * 0.6190278,
        size.height * 0.3656250,
        size.width * 0.6666667,
        size.height * 0.5343750,
        size.width * 0.7145833,
        size.height * 0.5165625);
    path_0.cubicTo(
        size.width * 0.7618750,
        size.height * 0.5000000,
        size.width * 0.8097222,
        size.height * 0.3000000,
        size.width * 0.8569444,
        size.height * 0.3334375);
    path_0.cubicTo(
        size.width * 0.9047917,
        size.height * 0.3656250,
        size.width * 0.9520833,
        size.height * 0.6343750,
        size.width * 0.9763889,
        size.height * 0.7665625);
    path_0.lineTo(size.width, size.height * 0.9000000);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width * 0.9761806, 0);
    path_0.cubicTo(size.width * 0.9523611, 0, size.width * 0.9048611, 0,
        size.width * 0.8569444, 0);
    path_0.cubicTo(size.width * 0.8095139, 0, size.width * 0.7618056, 0,
        size.width * 0.7145833, 0);
    path_0.cubicTo(size.width * 0.6666667, 0, size.width * 0.6187500, 0,
        size.width * 0.5715278, 0);
    path_0.cubicTo(size.width * 0.5238194, 0, size.width * 0.4763889, 0,
        size.width * 0.4284722, 0);
    path_0.cubicTo(size.width * 0.3809722, 0, size.width * 0.3333333, 0,
        size.width * 0.2854167, 0);
    path_0.cubicTo(size.width * 0.2381250, 0, size.width * 0.1902778, 0,
        size.width * 0.1430556, 0);
    path_0.cubicTo(size.width * 0.09520833, 0, size.width * 0.04791667, 0,
        size.width * 0.02361111, 0);
    path_0.lineTo(0, 0);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.indigo.withOpacity(1);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.1000000);
    path_0.lineTo(size.width * 0.02381944, size.height * 0.1834375);
    path_0.cubicTo(
        size.width * 0.04763889,
        size.height * 0.2656250,
        size.width * 0.09513889,
        size.height * 0.4343750,
        size.width * 0.1430556,
        size.height * 0.5165625);
    path_0.cubicTo(
        size.width * 0.1904861,
        size.height * 0.6000000,
        size.width * 0.2381944,
        size.height * 0.6000000,
        size.width * 0.2854167,
        size.height * 0.5500000);
    path_0.cubicTo(
        size.width * 0.3333333,
        size.height * 0.5000000,
        size.width * 0.3812500,
        size.height * 0.4000000,
        size.width * 0.4284722,
        size.height * 0.4000000);
    path_0.cubicTo(
        size.width * 0.4761806,
        size.height * 0.4000000,
        size.width * 0.5236111,
        size.height * 0.5000000,
        size.width * 0.5715278,
        size.height * 0.4834375);
    path_0.cubicTo(
        size.width * 0.6190278,
        size.height * 0.4656250,
        size.width * 0.6666667,
        size.height * 0.3343750,
        size.width * 0.7145833,
        size.height * 0.3165625);
    path_0.cubicTo(
        size.width * 0.7618750,
        size.height * 0.3000000,
        size.width * 0.8097222,
        size.height * 0.4000000,
        size.width * 0.8569444,
        size.height * 0.4000000);
    path_0.cubicTo(
        size.width * 0.9047917,
        size.height * 0.4000000,
        size.width * 0.9520833,
        size.height * 0.3000000,
        size.width * 0.9763889,
        size.height * 0.2500000);
    path_0.lineTo(size.width, size.height * 0.2000000);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width * 0.9761806, size.height);
    path_0.cubicTo(size.width * 0.9523611, size.height, size.width * 0.9048611,
        size.height, size.width * 0.8569444, size.height);
    path_0.cubicTo(size.width * 0.8095139, size.height, size.width * 0.7618056,
        size.height, size.width * 0.7145833, size.height);
    path_0.cubicTo(size.width * 0.6666667, size.height, size.width * 0.6187500,
        size.height, size.width * 0.5715278, size.height);
    path_0.cubicTo(size.width * 0.5238194, size.height, size.width * 0.4763889,
        size.height, size.width * 0.4284722, size.height);
    path_0.cubicTo(size.width * 0.3809722, size.height, size.width * 0.3333333,
        size.height, size.width * 0.2854167, size.height);
    path_0.cubicTo(size.width * 0.2381250, size.height, size.width * 0.1902778,
        size.height, size.width * 0.1430556, size.height);
    path_0.cubicTo(
        size.width * 0.09520833,
        size.height,
        size.width * 0.04791667,
        size.height,
        size.width * 0.02361111,
        size.height);
    path_0.lineTo(0, size.height);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.indigo.withOpacity(1);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
