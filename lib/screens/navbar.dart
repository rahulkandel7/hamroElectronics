import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/productController.dart';
import 'wishlist_screen.dart';
import 'cartScreen.dart';
import 'categoryScreen.dart';
import 'homepage.dart';
import 'profile_screen.dart';
import '../controllers/cartController.dart';
import '../controllers/wishlistController.dart';
import '../controllers/bannerController.dart';
import '../controllers/categoryController.dart';
import '../controllers/notificationController.dart';
import '../controllers/toppicksController.dart';
import '../main.dart';

class Navbar extends StatefulWidget {
  static const routeName = "/navbar";

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  final productController = Get.put(ProductController());
  final wishlistController = Get.put(WishlistController());
  final cartController = Get.put(CartController());
  final categoryController = Get.put(CategoryController());
  final notificationController = Get.put(NotificationController());
  final bannerController = Get.put(BannerController());
  final toppicksController = Get.put(ToppicksController());

  final List<Widget> _widgetOptions = [
    HomePage(),
    CategoryScreen(),
    CartScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  String userName = "";
  String token = "";
  int userid = 0;

  _getUserName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    var userInfo = _prefs.getString('user');
    var userDecoded = json.decode(userInfo!) as Map<String, dynamic>;

    setState(() {
      userName = userDecoded["name"];
      userid = userDecoded["id"] as int;
      token = _prefs.getString('token').toString();
    });
  }

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

    cartController.fetchCart(userid.toString());
    wishlistController.fetchWishlist(userid.toString());
    categoryController.fetchCtaegory();

    notificationController.fetchNotification();
    bannerController.fetchBanner();
    toppicksController.fetchToppicks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.indigo,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInCubic,
        buttonBackgroundColor: Colors.indigo,
        height: 60,
        animationDuration: const Duration(milliseconds: 500),
        items: const [
          Icon(
            Icons.home_filled,
            size: 24,
            color: Colors.white,
          ),
          Icon(
            Icons.category,
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
