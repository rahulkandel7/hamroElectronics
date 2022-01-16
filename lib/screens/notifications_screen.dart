import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notificationController.dart';

class NotificationScreen extends StatelessWidget {
  static const routeName = '/notifications';

  NotificationScreen({Key? key}) : super(key: key);

  final notificationController = Get.find<NotificationController>();

  Future<void> _onrefresh() async {
    await notificationController.fetchNotification();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: FutureBuilder(
        future: notificationController.fetchNotification(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: RefreshIndicator(
                color: Colors.indigo,
                onRefresh: () => _onrefresh(),
                child: SizedBox(
                  height: mediaQuery.height * 0.9,
                  child: Obx(
                    () {
                      return ListView.builder(
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    offset: Offset(4, 4),
                                    color: Theme.of(context).shadowColor,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // SizedBox(
                                  //   width: 80,
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(
                                  //       10,
                                  //     ),
                                  //     child: Image.asset(
                                  //       'assets/2.jpeg',
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: mediaQuery.width * 0.02,
                                        vertical: mediaQuery.height * 0.01),
                                    child: SizedBox(
                                      width: mediaQuery.width * 0.9,
                                      child: Text(
                                        notificationController
                                            .notification[i].title,
                                        maxLines: 3,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mediaQuery.width * 0.02,
                                        bottom: mediaQuery.height * 0.01),
                                    child: SizedBox(
                                      width: mediaQuery.width * 0.9,
                                      child: Text(
                                        notificationController
                                            .notification[i].description,
                                        maxLines: 4,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: mediaQuery.width * 0.02,
                                        bottom: mediaQuery.height * 0.01),
                                    child: SizedBox(
                                      width: mediaQuery.width * 0.9,
                                      child: Text(
                                        notificationController
                                            .notification[i].date,
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                decoration:
                                                    TextDecoration.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: notificationController.notification.length,
                      );
                    },
                  ),
                ),
              ),
            );
          } else {
            return SizedBox(
              height: mediaQuery.height * 9,
              child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: mediaQuery.width * 0.3,
                          height: mediaQuery.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            color: Colors.grey.shade300,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              width: mediaQuery.width * 0.6,
                              height: mediaQuery.height * 0.03,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Colors.grey.shade300,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 5),
                              width: mediaQuery.width * 0.4,
                              height: mediaQuery.height * 0.03,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: 8,
              ),
            );
          }
        },
      ),
    );
  }
}
