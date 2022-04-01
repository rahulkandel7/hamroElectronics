import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/authController.dart';
import '../screens/navbar.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _editprofilekey = GlobalKey<FormState>();

  final _authController = Get.find<AuthController>();

  File _image = File('');
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildImage() {
    if (_image == null) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Text('Select Image'),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            20,
          ),
          child: Image.file(
            _image as File,
            fit: BoxFit.cover,
          ),
        ),
      );
      // Container(
      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10000)),
      //   height: MediaQuery.of(context).size.height * 0.3,
      //   width: MediaQuery.of(context).size.width * 0.3,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(10000),
      //     child: Image.file(_image as File),
      //   ),
      // );
    }
  }

  late String? userName;
  late String? userEmail;
  late String? userNumber;
  late String? userAddress;
  late String? uphoto;
  String? oldPassword;
  String? newPassword;
  String? cPassword;

  bool hasToken = false;

  String token = "";
  int userid = 0;

  _getUserName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');
    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      userName = userDecoded["name"];
      userid = userDecoded["id"] as int;
      userName = userDecoded["name"] as String;
      userEmail = userDecoded["email"] as String;
      userNumber = userDecoded["phone"] as String;
      userAddress = userDecoded["address"] as String;
      uphoto = userDecoded["photopath"];
      token = _prefs.getString('token').toString();
    });
  }

  _getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      hasToken = _prefs.getString('token') == null ? false : true;
    });
  }

  _updateProfile() async {
    _editprofilekey.currentState!.save();

    if (!_editprofilekey.currentState!.validate()) {
      return;
    }

    _authController
        .updateUser(
      context,
      userid.toString(),
      userName.toString(),
      userEmail.toString(),
      userNumber.toString(),
      userAddress.toString(),
      oldPassword.toString(),
      newPassword.toString(),
      cPassword.toString(),
      token,
      _image.path,
    )
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Profile Updated Sucessfully',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        elevation: 5.0,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            1000,
          ),
        ),
      ));
    }).then((_) {
      Navigator.of(context).pushReplacementNamed(Navbar.routeName);
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getToken();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 29,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: TextButton(
                onPressed: () {
                  getImage();
                },
                child: _image.isAbsolute
                    ? _buildImage()
                    : Column(
                        children: [
                          CircleAvatar(
                            maxRadius: mediaQuery.width * 0.2,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                const AssetImage('assets/logo/logo.png'),
                            foregroundImage: hasToken
                                ? NetworkImage(
                                    'https://hamroelectronics.com.np/images/users/$uphoto',
                                  )
                                : NetworkImage(
                                    'https://www.kindpng.com/picc/m/252-2524695_dummy-profile-image-jpg-hd-png-download.png',
                                  ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: mediaQuery.height * 0.01),
                            child: FittedBox(
                              child: Text(
                                'Upload Profile Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.04),
              child: Form(
                key: _editprofilekey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.02),
                      child: Text(
                        'Edit Info',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.01),
                      child: TextFormField(
                        initialValue: userName,
                        onSaved: (value) {
                          userName = value.toString();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name Field Required';
                          }
                        },
                        decoration: InputDecoration(
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
                          labelText: 'Full Name',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[300],
                            fontFamily: 'Poppins',
                          ),
                          prefixIcon: const Icon(
                            Icons.person,
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
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    //Email Field
                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                      child: TextFormField(
                        readOnly: true,
                        initialValue: userEmail,
                        onSaved: (value) {
                          userEmail = value.toString();
                        },
                        onEditingComplete: () {},
                        validator: (value) {},
                        decoration: InputDecoration(
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
                          labelText: 'Email Address',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
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

                    //Phone Number
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQuery.height * 0.02,
                      ),
                      child: TextFormField(
                        initialValue: userNumber,
                        onSaved: (value) {
                          userNumber = value.toString();
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
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
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
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[300],
                          ),
                          prefixIcon: const Icon(
                            Icons.phone_android,
                            color: Colors.indigo,
                          ),
                          prefixText: '+977-',
                          prefixStyle: Theme.of(context).textTheme.bodyText2,
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
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    //Address Field
                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                      child: TextFormField(
                        initialValue: userAddress,
                        onSaved: (value) {
                          userAddress = value.toString();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Address is Required';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Address',
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            Icons.location_on,
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
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.02),
                      child: Text(
                        'Change Password',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    //Password Field
                    TextFormField(
                      onSaved: (value) {
                        oldPassword = value.toString();
                      },
                      decoration: InputDecoration(
                        labelText: 'Old Password',
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
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: const Icon(
                          Icons.lock,
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
                      obscureText: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                      child: TextFormField(
                        onSaved: (value) {
                          newPassword = value.toString();
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
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
                            Icons.lock,
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
                        obscureText: true,
                      ),
                    ),

                    //Confirm Password
                    Padding(
                      padding: EdgeInsets.only(
                        top: mediaQuery.height * 0.02,
                      ),
                      child: TextFormField(
                        onSaved: (value) {
                          cPassword = value.toString();
                        },
                        validator: (value) {
                          if (value != newPassword) {
                            return 'Confirm Password Doesnt Match';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
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
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[300],
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
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
                        obscureText: true,
                      ),
                    ),

                    //update Button

                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: mediaQuery.height * 0.01),
                        child: SizedBox(
                          width: mediaQuery.width * 0.35,
                          child: ElevatedButton(
                            onPressed: () => _updateProfile(),
                            style: ElevatedButton.styleFrom(
                              enableFeedback: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                'Update Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
