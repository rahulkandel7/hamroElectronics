import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamro_electronics/screens/signup_screen.dart';

import 'package:url_launcher/url_launcher.dart';

import '../screens/forgetpassword_screen.dart';
import '../controllers/authController.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();

  //Login Focus Node
  final FocusNode _loginpassword = FocusNode();

  void _launchBITS() async {
    if (!await launch(
      "https://www.bitmapitsolution.com",
      forceWebView: false,
      forceSafariVC: false,
    )) throw 'Could not launch ';
  }

  final _authController = Get.put(AuthController());

  String email = '';
  String password = '';

  @override
  void dispose() {
    super.dispose();
    _loginpassword.dispose();
  }

  late String tokens;
  bool isLoading = false;

  userLogin() {
    _loginKey.currentState!.save();

    if (!_loginKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    // FirebaseMessaging.instance.getToken().then((token) {
    //   setState(() {
    //     tokens = token.toString();
    //   });
    //   print(tokens);
    // }).then((_) {
    //   _authController.login(email, password, context);
    //   FirebaseMessaging.instance.subscribeToTopic('all');

    //   setState(() {
    //     isLoading = false;
    //   });
    // });

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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 0.6,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomPaint(
                    size: Size(
                        double.infinity,
                        (400 * 0.22222222222222224)
                            .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: RPSCustomPainter(),
                  ),
                  SizedBox(
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
                            key: _loginKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  style: const TextStyle(color: Colors.black),
                                  onSaved: (value) {
                                    email = value.toString().trim();
                                  },
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus(_loginpassword);
                                  },
                                  validator: (value) {
                                    if (value!.trim().isEmail) {
                                      return null;
                                    } else {
                                      return 'Email Field Required';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    errorStyle: Theme.of(context)
                                        .textTheme
                                        .caption
                                        ?.copyWith(
                                          decoration: TextDecoration.none,
                                          color: Colors.red.shade800,
                                        ),
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
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      errorStyle: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(
                                            decoration: TextDecoration.none,
                                            color: Colors.red.shade800,
                                          ),
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
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                  ),
                                ),
                                //Login Button

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: mediaQuery.height * 0.01),
                                  child: SizedBox(
                                    width: mediaQuery.width * 0.3,
                                    child: ElevatedButton(
                                      onPressed: () => userLogin(),
                                      style: ElevatedButton.styleFrom(
                                        enableFeedback: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 2.0),
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
                                    Navigator.of(context).pushNamed(
                                        ForgetPasswordScreen.routeName);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 6.0),
                                    child: Text(
                                      'Forget Password ?',
                                      style: TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: mediaQuery.height * 0.02),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              const SignupScreen(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));

                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 6.0),
                                      child: Text(
                                        "Don't have an account ? Sign Up",
                                        style: TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                                        const Text(
                                          'Powered By:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: mediaQuery.width * 0.02),
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
