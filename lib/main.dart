import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

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
  bool isFirst = _prefs.getBool('isFirst') == null ? true : false;

  runApp(MyApp(isFirst));
}

class MyApp extends StatelessWidget {
  final bool isFirst;

  const MyApp(this.isFirst, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      title: 'Hamro Electronic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.grey[100],
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          headline5: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          caption: TextStyle(
            decoration: TextDecoration.lineThrough,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
          headline6: TextStyle(
            color: Colors.indigo,
            fontFamily: 'Poppins',
          ),
          subtitle1: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
          bodyText2: TextStyle(
            color: Colors.indigo,
            fontFamily: 'Poppins',
          ),
          headline4: TextStyle(
            color: Colors.indigo,
            fontFamily: 'Poppins',
          ),
          subtitle2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        shadowColor: Colors.black12,
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.grey[900],
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          headline5: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          subtitle2: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          caption: TextStyle(
            decoration: TextDecoration.lineThrough,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
          subtitle1: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          headline6: TextStyle(
            color: Colors.indigo,
            fontFamily: 'Poppins',
          ),
          headline4: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          bodyText1: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
          bodyText2: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shadowColor: Colors.white12,
      ),
      themeMode: ThemeMode.system,
      home: isFirst ? OnBoardingScreen() : const Navbar(),
      // hasToken ? AuthScreen() : Navbar(),
      routes: {
        Navbar.routeName: (ctx) => const Navbar(),
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        SignupScreen.routeName: (ctx) => const SignupScreen(),
        ProductViewScreen.routeName: (ctx) => const ProductViewScreen(),
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
