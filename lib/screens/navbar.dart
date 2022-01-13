import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hamro_electronics/controllers/themeController.dart';

import 'wishlist_screen.dart';
import 'cartScreen.dart';
import 'categoryScreen.dart';
import 'homepage.dart';
import 'profile_screen.dart';
import '../main.dart';

class Navbar extends StatefulWidget {
  static const routeName = "/navbar";

  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final themeController = Get.put(ThemeController());

  final List<Widget> _widgetOptions = [
    HomePage(),
    CategoryScreen(),
    CartScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          var initializationSettingsAndroid =
              const AndroidInitializationSettings('@mipmap/launcher_icon');
          var iosInitilize = const IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: true,
          );
          var initializationSettings = InitializationSettings(
              android: initializationSettingsAndroid, iOS: iosInitilize);
          flutterLocalNotificationsPlugin.initialize(
            initializationSettings,
          );

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.transparent,
                playSound: true,
                enableVibration: true,
                importance: Importance.high,
                visibility: NotificationVisibility.public,
                channelShowBadge: true,
              ),
              iOS: const IOSNotificationDetails(
                presentSound: true,
                presentAlert: true,
                presentBadge: true,
              ),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    themeController.getThemeStatus();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBody: true,
      body: _connectionStatus == ConnectivityResult.none
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Image.asset('assets/Noconnection.png'),
                  ),
                  Text(
                    'Oops! No Connection',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.055,
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    child: Text(
                      'No internet connection found. Check your connection or try again',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.indigo,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInCubic,
        buttonBackgroundColor: Colors.indigo,
        height: 60,
        animationDuration: const Duration(milliseconds: 400),
        items: const [
          Icon(
            Icons.home_filled,
            size: 24,
            color: Colors.white,
          ),
          Icon(
            Icons.list,
            size: 24,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_cart,
            size: 24,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            size: 24,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 24,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
