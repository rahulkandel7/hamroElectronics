import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';

import '../screens/forgetpassword_screen.dart';
import '../models/user.dart';
import '../controllers/authController.dart';
import '../controllers/imageController.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  //Sign UP Focus Nodes
  final FocusNode _signupEmail = FocusNode();
  final FocusNode _signuppassword = FocusNode();
  final FocusNode _signupcpassword = FocusNode();
  final FocusNode _signupphone = FocusNode();
  final FocusNode _signupaddress = FocusNode();

  //Login Focus Node
  final FocusNode _loginpassword = FocusNode();

  late TabController _controller;

  void _launchBITS() async {
    if (!await launch(
      "https://www.bitmapitsolution.com",
      forceWebView: false,
      forceSafariVC: false,
    )) throw 'Could not launch ';
  }

  final _imageController = Get.put(ImageController());
  final _authController = Get.put(AuthController());

  int _activeIndex = 0;

  var _user = User(
    name: '',
    email: '',
    password: '',
    confirmpassword: '',
    profile: '',
    phone: '',
    address: '',
  );

  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _signupEmail.dispose();
    _signuppassword.dispose();
    _signupcpassword.dispose();
    _signupphone.dispose();
    _signupaddress.dispose();
    _loginpassword.dispose();
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

  userLogin() {
    _loginKey.currentState!.save();

    if (!_loginKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    _authController.login(email, password, context).then((_) {
      FirebaseMessaging.instance.subscribeToTopic('all');
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    _controller.addListener(() {
      setState(() {
        _activeIndex = _controller.index;
      });
    });
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
                child: SizedBox(
                  height: mediaQuery.height * 0.97,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: mediaQuery.height * 0.32,
                        decoration: const BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(1000),
                            bottomRight: Radius.circular(
                              1000,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -mediaQuery.height * 0.04,
                        right: -mediaQuery.width * 0.05,
                        child: SizedBox(
                          width: mediaQuery.width * 0.5,
                          child: Transform.rotate(
                            angle: 106,
                            child: _activeIndex == 0
                                ? Image.asset('assets/headset.png')
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        top: mediaQuery.width * 0.3,
                        left: mediaQuery.width * 0.05,
                        child: SizedBox(
                          width: mediaQuery.width * 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black38,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: mediaQuery.height * 0.02,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: mediaQuery.width * 0.4,
                                      child:
                                          Image.asset('assets/logo/logo.png'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: TabBar(
                                    isScrollable: false,
                                    controller: _controller,
                                    indicatorColor: Colors.indigo,
                                    labelStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    unselectedLabelColor:
                                        Colors.indigo.shade200,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelColor: Colors.indigo,
                                    unselectedLabelStyle: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    tabs: const [
                                      Tab(
                                        text: 'Login',
                                      ),
                                      Tab(
                                        text: 'Sign Up',
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  height: _activeIndex == 0
                                      ? mediaQuery.height * 0.41
                                      : mediaQuery.height * 0.62,
                                  child: TabBarView(
                                    controller: _controller,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: mediaQuery.width * 0.06,
                                          vertical: mediaQuery.height * 0.03,
                                        ),
                                        child: Form(
                                          key: _loginKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                onSaved: (value) {
                                                  email = value.toString();
                                                },
                                                onEditingComplete: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _loginpassword);
                                                },
                                                validator: (value) {
                                                  if (value!.isEmail) {
                                                    return null;
                                                  } else {
                                                    return 'Email Field Required';
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  labelText: 'Email Address',
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
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
                                                    borderSide:
                                                        const BorderSide(
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
                                                  prefixIcon: Icon(
                                                    Icons.email,
                                                    color: Colors.indigo,
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  disabledBorder:
                                                      InputBorder.none,
                                                  isDense: true,
                                                  floatingLabelStyle:
                                                      const TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 1.0,
                                                      color: Colors.indigo,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1.0,
                                                      color: Colors
                                                          .indigo.shade100,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                cursorColor: Colors.indigo,
                                                enabled: true,
                                                enableSuggestions: true,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                              ),

                                              //Password Field
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: mediaQuery.height * 0.02,
                                                ),
                                                child: TextFormField(
                                                  focusNode: _loginpassword,
                                                  onSaved: (value) {
                                                    password = value.toString();
                                                  },
                                                  validator: (value) {
                                                    if (value!.length > 7) {
                                                      return null;
                                                    } else {
                                                      return "Password Doesn't match ";
                                                    }
                                                  },
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: 'Password',
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
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
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1.0,
                                                        color: Colors.indigo,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                    labelStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.indigo[300],
                                                    ),
                                                    prefixIcon: const Icon(
                                                      Icons.lock,
                                                      color: Colors.indigo,
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets.all(0),
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    isDense: true,
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                        width: 1.0,
                                                        color: Colors.indigo,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        width: 1.0,
                                                        color: Colors
                                                            .indigo.shade100,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  cursorColor: Colors.indigo,
                                                  enabled: true,
                                                  enableSuggestions: true,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  obscureText: true,
                                                ),
                                              ),
                                              //Login Button
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        mediaQuery.height *
                                                            0.02),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            ForgetPasswordScreen
                                                                .routeName);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 6.0),
                                                    child: Text(
                                                      'Forget Password ?',
                                                      style: TextStyle(
                                                        color: Colors.indigo,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: mediaQuery.width * 0.3,
                                                child: ElevatedButton(
                                                  onPressed: () => userLogin(),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    enableFeedback: true,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Text(
                                                        'Login',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward,
                                                        size: 16,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _launchBITS();
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: mediaQuery.height *
                                                        0.01,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Powered By:',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.indigo,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: mediaQuery
                                                                        .width *
                                                                    0.02),
                                                        child: Text(
                                                          'BITS',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.red[800],
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
                                      //SignUP Form
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: mediaQuery.width * 0.06,
                                          vertical: mediaQuery.height * 0.03,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Form(
                                            key: _signupKey,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: mediaQuery.height *
                                                          0.01),
                                                  child: TextFormField(
                                                    onSaved: (value) {
                                                      _user = User(
                                                        name: value.toString(),
                                                        email: _user.email,
                                                        password:
                                                            _user.password,
                                                        confirmpassword: _user
                                                            .confirmpassword,
                                                        profile: _user.profile,
                                                        phone: _user.phone,
                                                        address: _user.address,
                                                      );
                                                    },
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _signupEmail);
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Name Field Required';
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      labelText: 'Full Name',
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.indigo[300],
                                                      ),
                                                      prefixIcon: const Icon(
                                                        Icons.person,
                                                        color: Colors.indigo,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      isDense: true,
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .indigo.shade100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    cursorColor: Colors.indigo,
                                                    enabled: true,
                                                    enableSuggestions: true,
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),
                                                ),
                                                //Email Field
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: mediaQuery.height *
                                                          0.02),
                                                  child: TextFormField(
                                                    focusNode: _signupEmail,
                                                    onSaved: (value) {
                                                      _user = User(
                                                        name: _user.name,
                                                        email: value.toString(),
                                                        password:
                                                            _user.password,
                                                        confirmpassword: _user
                                                            .confirmpassword,
                                                        profile: _user.profile,
                                                        phone: _user.phone,
                                                        address: _user.address,
                                                      );
                                                    },
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _signuppassword);
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmail) {
                                                        return null;
                                                      } else {
                                                        return 'Name Field Required';
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      labelText:
                                                          'Email Address',
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.indigo[300],
                                                      ),
                                                      prefixIcon: const Icon(
                                                        Icons.email,
                                                        color: Colors.indigo,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      isDense: true,
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .indigo.shade100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    cursorColor: Colors.indigo,
                                                    enabled: true,
                                                    enableSuggestions: true,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                  ),
                                                ),
                                                //Password Field
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: mediaQuery.height *
                                                        0.02,
                                                  ),
                                                  child: TextFormField(
                                                    focusNode: _signuppassword,
                                                    onSaved: (value) {
                                                      _user = User(
                                                        name: _user.name,
                                                        email: _user.email,
                                                        password:
                                                            value.toString(),
                                                        confirmpassword: _user
                                                            .confirmpassword,
                                                        profile: _user.profile,
                                                        phone: _user.phone,
                                                        address: _user.address,
                                                      );
                                                    },
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _signupcpassword);
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Password Field Required';
                                                      } else if (value.length <
                                                          8) {
                                                        return 'Password Length Should be more than 8 characters';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      labelText: 'Password',
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.indigo[300],
                                                      ),
                                                      prefixIcon: const Icon(
                                                        Icons.lock,
                                                        color: Colors.indigo,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      isDense: true,
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .indigo.shade100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    cursorColor: Colors.indigo,
                                                    enabled: true,
                                                    enableSuggestions: true,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    obscureText: true,
                                                  ),
                                                ),
                                                //Confirm Password
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: mediaQuery.height *
                                                        0.02,
                                                  ),
                                                  child: TextFormField(
                                                    focusNode: _signupcpassword,
                                                    onSaved: (value) {
                                                      _user = User(
                                                        name: _user.name,
                                                        email: _user.email,
                                                        password:
                                                            _user.password,
                                                        confirmpassword:
                                                            value.toString(),
                                                        profile: _user.profile,
                                                        phone: _user.phone,
                                                        address: _user.address,
                                                      );
                                                    },
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _signupphone);
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
                                                      labelText:
                                                          'Confirm Password',
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.indigo[300],
                                                      ),
                                                      prefixIcon: const Icon(
                                                        Icons.lock,
                                                        color: Colors.indigo,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      isDense: true,
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .indigo.shade100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    cursorColor: Colors.indigo,
                                                    enabled: true,
                                                    enableSuggestions: true,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    obscureText: true,
                                                  ),
                                                ),
                                                //Phone Number
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: mediaQuery.height *
                                                        0.02,
                                                  ),
                                                  child: TextFormField(
                                                    focusNode: _signupphone,
                                                    onSaved: (value) {
                                                      _user = User(
                                                        name: _user.name,
                                                        email: _user.email,
                                                        password:
                                                            _user.password,
                                                        confirmpassword: _user
                                                            .confirmpassword,
                                                        profile: _user.profile,
                                                        phone: value.toString(),
                                                        address: _user.address,
                                                      );
                                                    },
                                                    onEditingComplete: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              _signupaddress);
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Phone Number is Required';
                                                      } else if (value.length !=
                                                          10) {
                                                        return 'Enter Valid Phone Number';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Mobile Number',
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.indigo[300],
                                                      ),
                                                      prefixIcon: const Icon(
                                                        Icons.phone_android,
                                                        color: Colors.indigo,
                                                      ),
                                                      prefixText: '+977-',
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      isDense: true,
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .indigo.shade100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    cursorColor: Colors.indigo,
                                                    enabled: true,
                                                    enableSuggestions: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ),
                                                //Address Field
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: mediaQuery.height *
                                                          0.02),
                                                  child: TextFormField(
                                                    focusNode: _signupaddress,
                                                    onSaved: (value) {
                                                      _user = User(
                                                        name: _user.name,
                                                        email: _user.email,
                                                        password:
                                                            _user.password,
                                                        confirmpassword: _user
                                                            .confirmpassword,
                                                        profile: _user.profile,
                                                        phone: _user.phone,
                                                        address:
                                                            value.toString(),
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
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.indigo[300],
                                                      ),
                                                      prefixIcon: const Icon(
                                                        Icons.location_on,
                                                        color: Colors.indigo,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      disabledBorder:
                                                          InputBorder.none,
                                                      isDense: true,
                                                      floatingLabelStyle:
                                                          const TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.0,
                                                          color: Colors.indigo,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          10,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .indigo.shade100,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    cursorColor: Colors.indigo,
                                                    enabled: true,
                                                    enableSuggestions: true,
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),
                                                ),

                                                //Signup Button

                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: mediaQuery.height *
                                                          0.01),
                                                  child: SizedBox(
                                                    width:
                                                        mediaQuery.width * 0.35,
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          userRegister(),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        enableFeedback: true,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          const Text(
                                                            'Sign Up',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const Icon(
                                                            Icons.arrow_forward,
                                                            size: 16,
                                                          ),
                                                        ],
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
                                                      top: mediaQuery.height *
                                                          0.01,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Powered By:',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.indigo,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left: mediaQuery
                                                                      .width *
                                                                  0.02),
                                                          child: Text(
                                                            'BITS',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .red[800],
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
