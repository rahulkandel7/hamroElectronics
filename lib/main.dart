import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/authController.dart';
import '../screens/auth_screen.dart';
import '../screens/product_view_screen.dart';
import '../screens/navbar.dart';
import '../screens/checkout_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/category_screen_items.dart';

import '../screens/cartScreen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/forgetpassword_screen.dart';
import '../screens/onboarding_screen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'id',
  'title',
  showBadge: true,
  importance: Importance.high,
  playSound: true,
  enableVibration: true,
  enableLights: true,
);

const IOSNotificationDetails ios = IOSNotificationDetails(
  presentBadge: true,
  presentAlert: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  bool hasToken = _prefs.getString('token') == null ? true : false;

  runApp(MyApp(hasToken));
}

class MyApp extends StatelessWidget {
  final bool hasToken;

  MyApp(this.hasToken, {Key? key}) : super(key: key);

  final authController = Get.put(AuthController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Hamro Electronic',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: hasToken ? AuthScreen() : Navbar(),
      routes: {
        Navbar.routeName: (ctx) => Navbar(),
        AuthScreen.routeName: (ctx) => AuthScreen(),
        ProductViewScreen.routeName: (ctx) => ProductViewScreen(),
        CheckOutScreen.routeName: (ctx) => CheckOutScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
        OrdersScreen.routeName: (ctx) => OrdersScreen(),
        NotificationScreen.routeName: (ctx) => NotificationScreen(),
        CategoryScreenItems.routeName: (ctx) => CategoryScreenItems(),
        EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
        OnBoardingScreen.routeName: (ctx) => OnBoardingScreen(),
        ForgetPasswordScreen.routeName: (ctx) => ForgetPasswordScreen(),
        CartScreen.routeName: (ctx) => CartScreen(),
      },
    );
  }
}
