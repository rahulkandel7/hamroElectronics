import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hamro_electronics/controllers/themeController.dart';
import 'package:hamro_electronics/screens/login_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/authController.dart';
import '../screens/notifications_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../controllers/statusController.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = Get.put(AuthController());
  final statusController = Get.put(StatusController());
  final themeController = Get.put(ThemeController());

  String? uname;
  String? uphoto;
  String? uid;

  bool hasToken = false;

  void _launchURL(String link) async {
    if (!await launch(
      "https://hamroelectronics.com.np/$link",
      forceWebView: false,
      forceSafariVC: false,
    )) throw 'Could not launch ';
  }

  _getUserInfo() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');

    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      uname = userDecoded["name"];
      uphoto = userDecoded["photopath"];
      uid = userDecoded["userid"];
    });
  }

  _getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      hasToken = _prefs.getString('token') == null ? false : true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    statusController.fetchStatus(uid.toString());
    _getToken();
  }

  Widget options(BuildContext context, IconData ico, String title) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mediaQuery.height * 0.015,
        horizontal: mediaQuery.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  ico,
                ),
                Padding(
                  padding: EdgeInsets.only(left: mediaQuery.width * 0.04),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_outlined)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.indigo,
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(vertical: mediaQuery.height * 0.03),
                child: Column(
                  children: [
                    CircleAvatar(
                      maxRadius: mediaQuery.width * 0.2,
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage('assets/logo/logo.png'),
                      foregroundImage: hasToken
                          ? NetworkImage(
                              'https://hamroelectronics.com.np/images/users/$uphoto',
                            )
                          : NetworkImage(
                              'https://www.kindpng.com/picc/m/252-2524695_dummy-profile-image-jpg-hd-png-download.png',
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.01),
                      child: Text(
                        uname ?? "",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: mediaQuery.height * 0.02),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.height * 0.01,
                    horizontal: mediaQuery.width * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.brightness_4_outlined,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: mediaQuery.width * 0.04),
                              child: Text(
                                'Light Mode',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        return Switch(
                          value: themeController.isLightTheme.value,
                          onChanged: (val) {
                            themeController.isLightTheme.value = val;
                            Get.changeThemeMode(
                              themeController.isLightTheme.value
                                  ? ThemeMode.light
                                  : ThemeMode.dark,
                            );
                            themeController.saveThemeStatus();
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              hasToken
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    EditProfileScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: options(context, Icons.person, 'Edit profile'))
                  : SizedBox(),
              hasToken
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    OrdersScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: options(context, Icons.history, 'Orders'))
                  : SizedBox(),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            NotificationScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child:
                      options(context, Icons.notifications, 'Notifications')),

              InkWell(
                onTap: () {
                  _launchURL('privacy-policy');
                },
                child: options(context, Icons.privacy_tip, 'Privacy Policy'),
              ),
              InkWell(
                onTap: () {
                  _launchURL('about-us');
                },
                child: options(context, Icons.book, 'About Us'),
              ),
              // options(context, Icons.star, 'Rate Us'),
              InkWell(
                onTap: () {
                  Platform.isAndroid
                      ? Share.share(
                          "https://bit.ly/3lWLutS",
                        )
                      : Share.share(
                          "https://apps.apple.com/us/app/hamro-electronics-shop-online/id1610534669");
                },
                child: options(context, Icons.share, 'Share'),
              ),
              hasToken
                  ? InkWell(
                      onTap: () => authController.logout(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.01,
                          horizontal: mediaQuery.width * 0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.logout,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mediaQuery.width * 0.04),
                                    child: Text(
                                      'Logout',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(LoginScreen.routeName);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height * 0.01,
                          horizontal: mediaQuery.width * 0.05,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.logout,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mediaQuery.width * 0.04),
                                    child: Text(
                                      'Login',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ],
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
    );
  }
}
