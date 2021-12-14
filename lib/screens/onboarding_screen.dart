import 'package:flutter/material.dart';
import '../screens/auth_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  static const routeName = '/onboardingscreen';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController(
    initialPage: 0,
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onIntroEnd(context) async {
    Navigator.of(context).pushReplacementNamed(
      AuthScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.428,
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.asset('assets/onboarding/news.png'),
                ),
                Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(34, 45, 102, 1),
                  height: MediaQuery.of(context).size.height * 0.5408,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: const Text(
                          'Sanchar Dainik, a leading  News Portal in Nepal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.13,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              onPressed: () => _onIntroEnd(context),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                controller.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInCubic,
                                );
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.428,
                  width: double.infinity,
                  color: Colors.white,
                  child: Image.asset('assets/onboarding/readnews.png'),
                ),
                Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(34, 45, 102, 1),
                  height: MediaQuery.of(context).size.height * 0.5408,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.04,
                        ),
                        child: const Text(
                          'Remain Updated about News and Events',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.13,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                controller.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInCubic,
                                );
                              },
                              child: const Text(
                                'Previous',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              onPressed: () => _onIntroEnd(context),
                              child: const Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
